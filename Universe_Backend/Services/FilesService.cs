using CloudinaryDotNet.Actions;
using CloudinaryDotNet;
using Microsoft.Extensions.Logging;
using Universe_Backend.Repositories;

namespace Universe_Backend.Services
{
    public class FilesService(ILogger<FilesService> logger, IConfiguration configuration) : IFilesService
    {
        public async Task<List<string>> UploadImage(string postId, List<IFormFile> images)
        {
            var tasks = new List<Task<ImageUploadResult>>();

            foreach (var image in images)
            {
                var readStream = image.OpenReadStream();
                logger.LogDebug($"File Details: {image.FileName}, {image.Length}");

                logger.LogDebug(configuration["CLOUDINARY_URL"]);
                var cloudinary = new Cloudinary(configuration["CLOUDINARY_URL"]);
                cloudinary.Api.Secure = true;

                string imageName = Guid.NewGuid().ToString();
                var uploadParams = new ImageUploadParams()
                {
                    File = new FileDescription(imageName, readStream),
                    PublicId = $"{postId}/Images/{imageName}",
                };

                var uploadTask = cloudinary.UploadAsync(uploadParams);

                tasks.Add(uploadTask);
            }

            var uploadResults = await Task.WhenAll(tasks);
            logger.LogDebug($"Cloudinary results: {uploadResults}");
            
            return uploadResults.Select(result => result.SecureUrl.ToString()).ToList();
        }

        public async Task<string> UploadVideo(string postId, List<IFormFile> videos)
        {
            var video = videos.First();
            var readStream = video.OpenReadStream();
            logger.LogDebug($"File Details: {video.FileName}, {video.Length}");

            logger.LogDebug(configuration["CLOUDINARY_URL"]);
            var cloudinary = new Cloudinary(configuration["CLOUDINARY_URL"]);
            cloudinary.Api.Secure = true;

            string videoName = "test";
            var uploadParams = new VideoUploadParams()
            {
                File = new FileDescription(videoName, readStream),
                PublicId = $"{postId}/Videos/{videoName}",
            };

            var uploadResult = await cloudinary.UploadAsync(uploadParams);
            logger.LogDebug($"Cloudinary result: {uploadResult}");

            return uploadResult.SecureUrl.ToString();
        }

        public async Task<string> UploadAudio(string postId, List<IFormFile> audios)
        {
            var audio = audios.First();
            var readStream = audio.OpenReadStream();
            logger.LogDebug($"File Details: {audio.FileName}, {audio.Length}");

            logger.LogDebug(configuration["CLOUDINARY_URL"]);
            var cloudinary = new Cloudinary(configuration["CLOUDINARY_URL"]);
            cloudinary.Api.Secure = true;

            string audioName = "test";
            var uploadParams = new VideoUploadParams()
            {
                File = new FileDescription(audioName, readStream),
                PublicId = $"{postId}/Audios/{audioName}",
            };

            var uploadResult = await cloudinary.UploadAsync(uploadParams);
            logger.LogDebug($"Cloudinary result: {uploadResult}");

            return uploadResult.SecureUrl.ToString();
        }
    }
}
