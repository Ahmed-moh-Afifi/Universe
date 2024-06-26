using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Universe_Backend.Migrations
{
    /// <inheritdoc />
    public partial class SharingInStory : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "SharedPostId",
                table: "Stories",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "SharedStoryId",
                table: "Stories",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Stories_SharedPostId",
                table: "Stories",
                column: "SharedPostId");

            migrationBuilder.CreateIndex(
                name: "IX_Stories_SharedStoryId",
                table: "Stories",
                column: "SharedStoryId");

            migrationBuilder.AddForeignKey(
                name: "FK_Stories_Posts_SharedPostId",
                table: "Stories",
                column: "SharedPostId",
                principalTable: "Posts",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Stories_Stories_SharedStoryId",
                table: "Stories",
                column: "SharedStoryId",
                principalTable: "Stories",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Stories_Posts_SharedPostId",
                table: "Stories");

            migrationBuilder.DropForeignKey(
                name: "FK_Stories_Stories_SharedStoryId",
                table: "Stories");

            migrationBuilder.DropIndex(
                name: "IX_Stories_SharedPostId",
                table: "Stories");

            migrationBuilder.DropIndex(
                name: "IX_Stories_SharedStoryId",
                table: "Stories");

            migrationBuilder.DropColumn(
                name: "SharedPostId",
                table: "Stories");

            migrationBuilder.DropColumn(
                name: "SharedStoryId",
                table: "Stories");
        }
    }
}
