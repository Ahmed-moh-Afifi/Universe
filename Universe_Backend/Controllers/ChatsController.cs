using Microsoft.AspNetCore.Mvc;
using Universe_Backend.Data.DTOs;
using Universe_Backend.Data.Models;
using Universe_Backend.Repositories;

namespace Universe_Backend.Controllers
{
    [ApiController]
    [Route("{userId}/[controller]")]
    public class ChatsController(IChatsRepository chatsRepository, IUsersRepository usersRepository, NotificationService.Interfaces.INotificationService notificationService, ILogger<ChatsRepository> logger) : ControllerBase
    {
        [HttpPost]
        [Route("{name}")]
        public async Task<ActionResult<ChatDTO>> CreateChatAsync(string userId, string name, [FromBody] StringListWrapper userIds)
        {
            try
            {
                var chat = await chatsRepository.CreateChatAsync(name, userIds.Strings);
                userIds.Strings.ForEach(async uid => await notificationService.SubscribeToTopicAsync([.. (await usersRepository.GetNotificationTokens(uid)).Select(nt => nt.Token)], chat.Id.ToString(), NotificationService.Models.Platform.Android));
                return Ok(chat.ToDTO());
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to create chat");
                return StatusCode(500);
            }
        }

        [HttpGet("")]
        public async Task<ActionResult<List<ChatDTO>>> GetUserChatsAsync(string userId)
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
        public async Task<ActionResult<ChatDTO>> GetChatAsync(string userId, int chatId)
        {
            try
            {
                var chat = await chatsRepository.GetChatAsync(userId, chatId);
                return Ok(chat);
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to get chat");
                return StatusCode(500);
            }
        }

        [HttpPost("{chatId}/Users/{addedUserId}/Add")]
        public async Task<ActionResult> AddUserToChatAsync(string userId, int chatId, string addedUserId)
        {
            try
            {
                await chatsRepository.AddUserToChatAsync(chatId, addedUserId);
                return Ok();
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to add user to chat");
                return StatusCode(500);
            }
        }

        [HttpPost("{chatId}/Users/{removedUserId}/Remove")]
        public async Task<ActionResult> RemoveUserFromChatAsync(string userId, int chatId, string removedUserId)
        {
            try
            {
                await chatsRepository.RemoveUserFromChatAsync(chatId, removedUserId);
                return Ok();
            }
            catch (Exception e)
            {
                logger.LogError(e, "Failed to remove user from chat");
                return StatusCode(500);
            }
        }

        [HttpDelete("{chatId}")]
        public async Task<ActionResult> DeleteChatAsync(string userId, int chatId)
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

        [HttpGet("{initiator}/And/{targeted}")]
        public async Task<ActionResult<ChatDTO>> GetChatByParticipants(string userId, string initiator, string targeted)
        {
            try
            {
                return Ok(await chatsRepository.GetChatByParticipantsAsync(initiator, targeted));
            }
            catch (Exception e)
            {
                logger.LogError(e, $"Failed to get chat. initiator: {initiator}, targeted: {targeted}");
                return StatusCode(500);
            }
        }
    }
}
