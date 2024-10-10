using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Universe_Backend.Migrations
{
    /// <inheritdoc />
    public partial class MessageReactionsRelation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Messages_Chats_ChatId",
                table: "Messages");

            migrationBuilder.DropForeignKey(
                name: "FK_Messages_Users_AuthorId",
                table: "Messages");

            migrationBuilder.DropForeignKey(
                name: "FK_PostReactions_Messages_MessageId",
                table: "PostReactions");

            migrationBuilder.DropForeignKey(
                name: "FK_Users_Messages_MessageId",
                table: "Users");

            migrationBuilder.DropIndex(
                name: "IX_Users_MessageId",
                table: "Users");

            migrationBuilder.DropIndex(
                name: "IX_PostReactions_MessageId",
                table: "PostReactions");

            migrationBuilder.DropColumn(
                name: "MessageId",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "MessageId",
                table: "PostReactions");

            migrationBuilder.CreateTable(
                name: "MessageReaction",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MessageId = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    ReactionType = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ReactionDate = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MessageReaction", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MessageReaction_Messages_MessageId",
                        column: x => x.MessageId,
                        principalTable: "Messages",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_MessageReaction_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "MessageUser",
                columns: table => new
                {
                    MentionsId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    MessagesMentionedInId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MessageUser", x => new { x.MentionsId, x.MessagesMentionedInId });
                    table.ForeignKey(
                        name: "FK_MessageUser_Messages_MessagesMentionedInId",
                        column: x => x.MessagesMentionedInId,
                        principalTable: "Messages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_MessageUser_Users_MentionsId",
                        column: x => x.MentionsId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_MessageReaction_MessageId",
                table: "MessageReaction",
                column: "MessageId");

            migrationBuilder.CreateIndex(
                name: "IX_MessageReaction_UserId",
                table: "MessageReaction",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_MessageUser_MessagesMentionedInId",
                table: "MessageUser",
                column: "MessagesMentionedInId");

            migrationBuilder.AddForeignKey(
                name: "FK_Messages_Chats_ChatId",
                table: "Messages",
                column: "ChatId",
                principalTable: "Chats",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Messages_Users_AuthorId",
                table: "Messages",
                column: "AuthorId",
                principalTable: "Users",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Messages_Chats_ChatId",
                table: "Messages");

            migrationBuilder.DropForeignKey(
                name: "FK_Messages_Users_AuthorId",
                table: "Messages");

            migrationBuilder.DropTable(
                name: "MessageReaction");

            migrationBuilder.DropTable(
                name: "MessageUser");

            migrationBuilder.AddColumn<int>(
                name: "MessageId",
                table: "Users",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "MessageId",
                table: "PostReactions",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Users_MessageId",
                table: "Users",
                column: "MessageId");

            migrationBuilder.CreateIndex(
                name: "IX_PostReactions_MessageId",
                table: "PostReactions",
                column: "MessageId");

            migrationBuilder.AddForeignKey(
                name: "FK_Messages_Chats_ChatId",
                table: "Messages",
                column: "ChatId",
                principalTable: "Chats",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Messages_Users_AuthorId",
                table: "Messages",
                column: "AuthorId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_PostReactions_Messages_MessageId",
                table: "PostReactions",
                column: "MessageId",
                principalTable: "Messages",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Users_Messages_MessageId",
                table: "Users",
                column: "MessageId",
                principalTable: "Messages",
                principalColumn: "Id");
        }
    }
}
