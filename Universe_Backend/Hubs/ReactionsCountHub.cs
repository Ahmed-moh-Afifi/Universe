using Microsoft.AspNetCore.SignalR;

namespace Universe_Backend.Hubs
{
    public class ReactionsCountHub(ILogger<ReactionsCountHub> logger) : Hub
    {
        public async Task JoinGroup(string postId)
        {
            logger.LogDebug($"Adding user {Context.ConnectionId} to group {postId}");
            await Groups.AddToGroupAsync(Context.ConnectionId, postId);
        }

        public async Task LeaveGroup(string postId)
        {
            logger.LogDebug($"Removing user {Context.ConnectionId} from group {postId}");
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, postId);
        }
    }
}
