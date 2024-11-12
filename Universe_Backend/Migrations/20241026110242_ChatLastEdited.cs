using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Universe_Backend.Migrations
{
    /// <inheritdoc />
    public partial class ChatLastEdited : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_MessageReaction_Messages_MessageId",
                table: "MessageReaction");

            migrationBuilder.DropForeignKey(
                name: "FK_MessageReaction_Users_UserId",
                table: "MessageReaction");

            migrationBuilder.DropPrimaryKey(
                name: "PK_MessageReaction",
                table: "MessageReaction");

            migrationBuilder.RenameTable(
                name: "MessageReaction",
                newName: "MessagesReactions");

            migrationBuilder.RenameIndex(
                name: "IX_MessageReaction_UserId",
                table: "MessagesReactions",
                newName: "IX_MessagesReactions_UserId");

            migrationBuilder.RenameIndex(
                name: "IX_MessageReaction_MessageId",
                table: "MessagesReactions",
                newName: "IX_MessagesReactions_MessageId");

            migrationBuilder.AddColumn<DateTime>(
                name: "LastEdited",
                table: "Chats",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddPrimaryKey(
                name: "PK_MessagesReactions",
                table: "MessagesReactions",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_MessagesReactions_Messages_MessageId",
                table: "MessagesReactions",
                column: "MessageId",
                principalTable: "Messages",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_MessagesReactions_Users_UserId",
                table: "MessagesReactions",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_MessagesReactions_Messages_MessageId",
                table: "MessagesReactions");

            migrationBuilder.DropForeignKey(
                name: "FK_MessagesReactions_Users_UserId",
                table: "MessagesReactions");

            migrationBuilder.DropPrimaryKey(
                name: "PK_MessagesReactions",
                table: "MessagesReactions");

            migrationBuilder.DropColumn(
                name: "LastEdited",
                table: "Chats");

            migrationBuilder.RenameTable(
                name: "MessagesReactions",
                newName: "MessageReaction");

            migrationBuilder.RenameIndex(
                name: "IX_MessagesReactions_UserId",
                table: "MessageReaction",
                newName: "IX_MessageReaction_UserId");

            migrationBuilder.RenameIndex(
                name: "IX_MessagesReactions_MessageId",
                table: "MessageReaction",
                newName: "IX_MessageReaction_MessageId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_MessageReaction",
                table: "MessageReaction",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_MessageReaction_Messages_MessageId",
                table: "MessageReaction",
                column: "MessageId",
                principalTable: "Messages",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_MessageReaction_Users_UserId",
                table: "MessageReaction",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
