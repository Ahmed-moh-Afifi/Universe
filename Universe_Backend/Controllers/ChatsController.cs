using Microsoft.AspNetCore.Mvc;
using Universe_Backend.Repositories;

namespace Universe_Backend.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ChatsController(IChatsRepository chatsRepository, ILogger<ChatsRepository> logger) : ControllerBase
    {
    }
}
