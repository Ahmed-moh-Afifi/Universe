using Microsoft.AspNetCore.Mvc;
using Universe_Backend.Data.Models;
using Universe_Backend.Repositories;

namespace Universe_Backend.Controllers
{
    [ApiController]
    [Route("{userId}/Chats/{chatId}/[controller]")]
    public class MessagesController(IMessagesRepository messagesRepository, ILogger<MessagesController> logger) : ControllerBase
    {
        [HttpPost]
        public async Task<ActionResult<Message>> CreateMessageAsync(string userId, int chatId, [FromBody] Message message)
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

        [HttpGet("")]
        public async Task<ActionResult<List<Message>>> GetChatMessagesAsync(string userId, int chatId)
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
        public async Task<ActionResult<Message>> GetMessageAsync(string userId, int chatId, int messageId)
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

        [HttpGet("{messageId}/Replies")]
        public async Task<ActionResult<List<Message>>> GetRepliesAsync(string userId, int chatId, int messageId)
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

        [HttpPost("{messageId}/Reactions")]
        public async Task<ActionResult> AddReactionAsync(string userId, int chatId, int messageId, [FromBody] MessageReaction reaction)
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

        [HttpDelete("{messageId}/Reactions/{reactionId}")]
        public async Task<ActionResult> RemoveReactionAsync(string userId, int chatId, int messageId, int reactionId)
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

        [HttpDelete("{messageId}/Delete")]
        public async Task<ActionResult> DeleteMessageAsync(string userId, int chatId, int messageId)
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
