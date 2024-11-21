using CloudinaryDotNet.Actions;
using Microsoft.AspNetCore.Mvc;
using CloudinaryDotNet;
using Universe_Backend.Repositories;
using Universe_Backend.Services;

namespace Universe_Backend.Controllers;

[ApiController]
[Route("{postId}/[controller]")]
public class FilesController(ILogger<FilesController> logger, IFilesService filesService) : ControllerBase
{
    [HttpPost("Images/Upload")]
    public async Task<ActionResult<List<string>>> UploadImage([FromForm] List<IFormFile> images)
    {
        logger.LogDebug($"FilesController -> UploadImage: Got {images.Count} images.");
        var imageUrls = await filesService.UploadImage(HttpContext.Request.RouteValues["postId"]!.ToString()!, images);
        return Ok(imageUrls);
    }

    [HttpPost("Videos/Upload")]
    public async Task<ActionResult<string>> UploadVideo([FromForm] List<IFormFile> videos)
    {
        logger.LogDebug("");
        var videoUrl = await filesService.UploadVideo(HttpContext.Request.RouteValues["postId"]!.ToString()!, videos);
        return Ok(videoUrl);
    }

    [HttpPost("Audios/Upload")]
    public async Task<ActionResult<string>> UploadAudio([FromForm] List<IFormFile> audios)
    {
        logger.LogDebug("");
        var audioUrl = await filesService.UploadAudio(HttpContext.Request.RouteValues["postId"]!.ToString()!, audios);
        return Ok(audioUrl);
    }
}
