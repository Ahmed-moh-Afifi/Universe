using Microsoft.AspNetCore.Mvc;
using Universe_Backend.Repositories;

namespace Universe_Backend.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ChatsController(IChatsRepository chatsRepository, ILogger<ChatsRepository> logger) : ControllerBase
    {
        [HttpPost]
        public async Task<IActionResult> CreateChatAsync(string name, IEnumerable<string> userIds)
        {
            try
            {
                var chat = await chatsRepository.CreateChatAsync(name, userIds);
                return Ok(chat);
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to create chat");
                return StatusCode(500);
            }
        }

        [HttpGet("Chats/{userId}")]
        public async Task<IActionResult> GetUserChatsAsync(string userId)
        {
            try
            {
                var chats = await chatsRepository.GetUserChatsAsync(userId);
                return Ok(chats);
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to get user chats");
                return StatusCode(500);
            }
        }

        [HttpGet("{chatId}")]
        public async Task<IActionResult> GetChatAsync(int chatId)
        {
            try
            {
                var chat = await chatsRepository.GetChatAsync(chatId);
                return Ok(chat);
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to get chat");
                return StatusCode(500);
            }
        }

        [HttpPost("{chatId}/addUser")]
        public async Task<IActionResult> AddUserToChatAsync(int chatId, string userId)
        {
            try
            {
                await chatsRepository.AddUserToChatAsync(chatId, userId);
                return Ok();
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to add user to chat");
                return StatusCode(500);
            }
        }

        [HttpPost("{chatId}/removeUser")]
        public async Task<IActionResult> RemoveUserFromChatAsync(int chatId, string userId)
        {
            try
            {
                await chatsRepository.RemoveUserFromChatAsync(chatId, userId);
                return Ok();
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to remove user from chat");
                return StatusCode(500);
            }
        }

        [HttpDelete("{chatId}")]
        public async Task<IActionResult> DeleteChatAsync(int chatId)
        {
            try
            {
                await chatsRepository.DeleteChatAsync(chatId);
                return Ok();
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to delete chat");
                return StatusCode(500);
            }
        }
    }
}
