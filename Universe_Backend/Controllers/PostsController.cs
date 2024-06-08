using Microsoft.AspNetCore.Mvc;
using UniverseBackend.Data;

namespace UniverseBackend.Controllers;

[ApiController]
[Route("[controller]")]
class PostsController(ApplicationDbContext dbContext, ILogger<PostsController> logger) : ControllerBase
{

}