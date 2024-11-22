namespace Universe_Backend.Services
{
    public interface IFilesService
    {
        public Task<List<string>> UploadImage(string postId, List<IFormFile> images);
        public Task<string> UploadVideo(string postId, List<IFormFile> videos);
        public Task<string> UploadAudio(string postId, List<IFormFile> audios);
    }
}
