using Universe_Backend.Data;

namespace Universe_Backend.Repositories
{
    public class FilesRepository(ApplicationDbContext dbContext) : IFilesRepository
    {
        public async Task AddImagesToPost(int postId, List<string> images)
        {
            var post = await dbContext.Posts.FindAsync(postId);
            if (post != null)
            {
                post.Images.AddRange(images);
                await dbContext.SaveChangesAsync();
            }
        }

        public async Task AddVideosToPost(int postId, List<string> videos)
        {
            var post = await dbContext.Posts.FindAsync(postId);
            if (post != null)
            {
                post.Videos.AddRange(videos);
                await dbContext.SaveChangesAsync();
            }
        }
    }
}
