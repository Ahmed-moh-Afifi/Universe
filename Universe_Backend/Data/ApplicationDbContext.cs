using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Universe_Backend.Data.Models;

namespace Universe_Backend.Data;

public class ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : IdentityDbContext<User>(options)
{
    public DbSet<RefreshToken> RefreshTokens { get; set; }
    public DbSet<Post> Posts { get; set; }
    public DbSet<PostReaction> PostsReactions { get; set; }
    public DbSet<StoryReaction> StoriesReactions { get; set; }
    public DbSet<Story> Stories { get; set; }
    public DbSet<Tag> Tags { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.Entity<User>().ToTable("Users").HasMany(u => u.Followers).WithMany(u => u.Following).UsingEntity(
        "Follows",
        typeof(Follow),
        r => r.HasOne(typeof(User)).WithMany().HasForeignKey("FollowerId").OnDelete(DeleteBehavior.NoAction),
        l => l.HasOne(typeof(User)).WithMany().HasForeignKey("FollowedId").OnDelete(DeleteBehavior.NoAction));
        modelBuilder.Entity<User>().ToTable("Users").HasMany(u => u.Posts).WithOne(p => p.Author).HasForeignKey(p => p.AuthorId).OnDelete(DeleteBehavior.NoAction);
        modelBuilder.Entity<User>().ToTable("Users").HasMany(u => u.Stories).WithOne(s => s.Author).HasForeignKey(s => s.AuthorId).OnDelete(DeleteBehavior.NoAction);
        modelBuilder.Entity<User>().ToTable("Users").HasMany(u => u.PostsMentionedIn).WithMany(p => p.Mentions);
        modelBuilder.Entity<User>().ToTable("Users").HasMany(u => u.StoriesMentionedIn).WithMany(s => s.Mentions);
        modelBuilder.Entity<Post>().ToTable("Posts").HasMany(p => p.Reactions).WithOne(r => r.Post).HasForeignKey(r => r.PostId).OnDelete(DeleteBehavior.NoAction);
        modelBuilder.Entity<Post>().ToTable("Posts").HasMany(p => p.Tags).WithMany(t => t.Posts);
        modelBuilder.Entity<Story>().ToTable("Stories").HasMany(s => s.Reactions).WithOne(r => r.Story).HasForeignKey(r => r.StoryId).OnDelete(DeleteBehavior.NoAction);
        modelBuilder.Entity<Story>().ToTable("Stories").HasMany(s => s.Tags).WithMany(t => t.Stories);
        modelBuilder.Entity<PostReaction>().ToTable("PostReactions").HasOne(pr => pr.User).WithMany(u => u.PostReactions).HasForeignKey("UserId").OnDelete(DeleteBehavior.NoAction);
        modelBuilder.Entity<StoryReaction>().ToTable("StoryReactions").HasOne(sr => sr.User).WithMany(u => u.StoryReactions).HasForeignKey("UserId").OnDelete(DeleteBehavior.NoAction);
    }
}