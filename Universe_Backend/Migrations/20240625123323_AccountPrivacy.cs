using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Universe_Backend.Migrations
{
    /// <inheritdoc />
    public partial class AccountPrivacy : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "AccountPrivacy",
                table: "Users",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AccountPrivacy",
                table: "Users");
        }
    }
}
