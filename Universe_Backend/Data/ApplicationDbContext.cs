using System.Net;
using Microsoft.EntityFrameworkCore;

namespace UniverseBackend.Data;

public class ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : DbContext(options)
{
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.Entity<User>().ToTable("Users");
        modelBuilder.Entity<Post>().ToTable("Posts");
        modelBuilder.Entity<Reaction>().ToTable("Reactions");
        modelBuilder.Entity<Follower>().ToTable("Followers").HasKey(f => new { f.FollowerId, f.FollowedId });
    }
}