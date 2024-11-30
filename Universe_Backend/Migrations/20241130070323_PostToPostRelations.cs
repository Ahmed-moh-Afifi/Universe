using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Universe_Backend.Migrations
{
    /// <inheritdoc />
    public partial class PostToPostRelations : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "ReplyToPost",
                table: "Posts",
                newName: "ReplyToPostId");

            migrationBuilder.CreateIndex(
                name: "IX_Posts_ChildPostId",
                table: "Posts",
                column: "ChildPostId");

            migrationBuilder.CreateIndex(
                name: "IX_Posts_ReplyToPostId",
                table: "Posts",
                column: "ReplyToPostId");

            migrationBuilder.AddForeignKey(
                name: "FK_Posts_Posts_ChildPostId",
                table: "Posts",
                column: "ChildPostId",
                principalTable: "Posts",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Posts_Posts_ReplyToPostId",
                table: "Posts",
                column: "ReplyToPostId",
                principalTable: "Posts",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Posts_Posts_ChildPostId",
                table: "Posts");

            migrationBuilder.DropForeignKey(
                name: "FK_Posts_Posts_ReplyToPostId",
                table: "Posts");

            migrationBuilder.DropIndex(
                name: "IX_Posts_ChildPostId",
                table: "Posts");

            migrationBuilder.DropIndex(
                name: "IX_Posts_ReplyToPostId",
                table: "Posts");

            migrationBuilder.RenameColumn(
                name: "ReplyToPostId",
                table: "Posts",
                newName: "ReplyToPost");
        }
    }
}
