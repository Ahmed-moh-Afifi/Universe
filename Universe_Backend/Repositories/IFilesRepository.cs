namespace Universe_Backend.Repositories
{
    public interface IFilesRepository
    {
        public Task AddImagesToPost(int postId, List<string> images);
        public Task AddVideosToPost(int postId, List<string> videos);
    }
}
