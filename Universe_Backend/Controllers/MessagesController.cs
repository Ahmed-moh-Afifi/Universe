using Microsoft.AspNetCore.Mvc;
using Universe_Backend.Data.Models;
using Universe_Backend.Repositories;

namespace Universe_Backend.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MessagesController(IMessagesRepository messagesRepository, ILogger<MessagesController> logger) : ControllerBase
    {
        [HttpPost]
        public async Task<IActionResult> CreateMessageAsync([FromBody] Message message)
        {
            try
            {
                await messagesRepository.AddMessageAsync(message);
                return Ok(message);
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to create message");
                return StatusCode(500);
            }
        }

        [HttpGet("Messages/{chatId}")]
        public async Task<IActionResult> GetChatMessagesAsync(int chatId)
        {
            try
            {
                var messages = await messagesRepository.GetChatMessagesAsync(chatId);
                return Ok(messages);
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to get chat messages");
                return StatusCode(500);
            }
        }

        [HttpGet("{messageId}")]
        public async Task<IActionResult> GetMessageAsync(int messageId)
        {
            try
            {
                var message = await messagesRepository.GetMessageAsync(messageId);
                return Ok(message);
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to get message");
                return StatusCode(500);
            }
        }

        [HttpGet("Replies/{messageId}")]
        public async Task<IActionResult> GetRepliesAsync(int messageId)
        {
            try
            {
                var replies = await messagesRepository.GetRepliesAsync(messageId);
                return Ok(replies);
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to get replies");
                return StatusCode(500);
            }
        }

        [HttpPost("Reactions")]
        public async Task<IActionResult> AddReactionAsync([FromBody] MessageReaction reaction)
        {
            try
            {
                await messagesRepository.AddReactionAsync(reaction);
                return Ok();
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to add reaction");
                return StatusCode(500);
            }
        }

        [HttpDelete("Reactions/{reactionId}")]
        public async Task<IActionResult> RemoveReactionAsync(int reactionId)
        {
            try
            {
                await messagesRepository.RemoveReactionAsync(reactionId);
                return Ok();
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to remove reaction");
                return StatusCode(500);
            }
        }

        [HttpDelete("{messageId}")]
        public async Task<IActionResult> DeleteMessageAsync(int messageId)
        {
            try
            {
                await messagesRepository.DeleteMessageAsync(messageId);
                return Ok();
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to delete message");
                return StatusCode(500);
            }
        }
    }
}
