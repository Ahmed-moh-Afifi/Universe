// using Microsoft.AspNetCore.Mvc;
// using UniverseBackend.Data;
// using UniverseBackend.Repositories;

// namespace Universe_Backend.Controllers;

// [ApiController]
// [Route("[controller]")]
// public class PostsController(IPostsRepository postsRepository, ILogger<PostsController> logger) : ControllerBase
// {
//     [HttpGet]
//     [Route("{userId}")]
//     public async Task<ActionResult<IEnumerable<Post>>> GetPosts(int userId)
//     {
//         return Ok(await postsRepository.GetPosts(userId));
//     }

//     [HttpGet]
//     [Route("replies/{postId}")]
//     public async Task<ActionResult<IEnumerable<Post>>> GetReplies(int postId)
//     {
//         return Ok(await postsRepository.GetReplies(postId));
//     }

//     [HttpPost]
//     [Route("")]
//     public async Task<ActionResult<int>> AddPost(Post post)
//     {
//         return Ok(await postsRepository.AddPost(post));
//     }

//     [HttpPost]
//     [Route("replies/")]
//     public async Task<ActionResult<int>> AddReply(Post reply)
//     {
//         return Ok(await postsRepository.AddReply(reply));
//     }

//     [HttpDelete]
//     [Route("{postId}")]
//     public async Task<ActionResult> RemovePost(int postId)
//     {
//         await postsRepository.RemovePost(postId);
//         return Ok();
//     }

//     [HttpDelete]
//     [Route("replies/{replyId}")]
//     public async Task<ActionResult> RemoveReply(int replyId)
//     {
//         await postsRepository.RemoveReply(replyId);
//         return Ok();
//     }
// }