using Microsoft.AspNetCore.SignalR;

namespace Universe_Backend.Hubs
{
    public class ReactionsCountHub(ILogger<ReactionsCountHub> logger) : Hub
    {
        public async Task JoinGroup(string connectionId, string postId)
        {
            logger.LogDebug($"Adding user {connectionId} to group {postId}");
            await Groups.AddToGroupAsync(connectionId, postId);
        }

        public async Task LeaveGroup(string connectionId, string postId)
        {
            logger.LogDebug($"Removing user {connectionId} from group {postId}");
            await Groups.RemoveFromGroupAsync(connectionId, postId);
        }
    }
}
