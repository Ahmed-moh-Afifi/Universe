// using Microsoft.AspNetCore.Mvc;
// using UniverseBackend.Data;
// using UniverseBackend.Repositories;

// namespace Universe_Backend.Controllers;

// [ApiController]
// [Route("[controller]")]
// public class ReactionsController(IReactionsRepository reactionsRepository, ILogger<ReactionsController> logger) : ControllerBase
// {
//     [HttpGet]
//     [Route("{postId}")]
//     public async Task<ActionResult<IEnumerable<Reaction>>> GetReactions(int postId)
//     {
//         return Ok(await reactionsRepository.GetReactions(postId));
//     }

//     [HttpGet]
//     [Route("count/{postId}")]
//     public async Task<ActionResult<int>> GetReactionsCount(int postId)
//     {
//         return Ok(await reactionsRepository.GetReactionsCount(postId));
//     }

//     [HttpPost]
//     [Route("")]
//     public async Task<ActionResult<int>> AddReaction(Reaction reaction)
//     {
//         return Ok(await reactionsRepository.AddReaction(reaction));
//     }

//     [HttpDelete]
//     [Route("{reactionId}")]
//     public async Task<ActionResult> RemoveReaction(int reactionId)
//     {
//         await reactionsRepository.RemoveReaction(reactionId);
//         return Ok();
//     }
// }