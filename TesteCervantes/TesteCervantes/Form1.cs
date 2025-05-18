using Npgsql;
using System;
using System.Configuration;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace TesteCervantes
{
    public partial class TesteCervantes : Form
    {
        public TesteCervantes()
        {
            InitializeComponent();

        }
        public class Connection
        {
            private static string connectionString;

            public static NpgsqlConnection getConnection()
            {
                try
                {
                    connectionString = ConfigurationManager.ConnectionStrings["PostgresConnection"].ConnectionString;
                    return new NpgsqlConnection(connectionString);
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Erro ao obter a conexão: {ex.Message}");
                    throw;
                }
            }
        }
        private void label1_Click(object sender, EventArgs e)
        {

        }


        private void TesteCervantes_Load(object sender, EventArgs e)
        {
            
        }

        private void createButton_Click(object sender, EventArgs e)
        {
            double codUser;
            if (!string.IsNullOrEmpty(nameText.Text) &&
                double.TryParse(codText.Text, out codUser))
            {
                if (codUser <= 0)
                {
                    MessageBox.Show("O código do usuário deve ser maior que zero.");
                    return;
                }

                using (var connection = Connection.getConnection())
                {
                    connection.Open();

                    string checkQuery = "SELECT COUNT(*) FROM cadastros WHERE coduser = @codUser";
                    using (var checkCommand = new NpgsqlCommand(checkQuery, connection))
                    {
                        checkCommand.Parameters.AddWithValue("@codUser", codUser);
                        int count = Convert.ToInt32(checkCommand.ExecuteScalar());

                        if (count > 0)
                        {
                            MessageBox.Show("Este código de usuário já existe. Escolha outro.");
                            return;
                        }
                    }

                    string query = "INSERT INTO cadastros (coduser, name) VALUES (@codUser, @name)";
                    using (var command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@codUser", codUser);
                        command.Parameters.AddWithValue("@name", nameText.Text);
                        command.ExecuteNonQuery();
                    }

                    MessageBox.Show("Usuário criado com sucesso!");
                    RegistrarLog("CREATE", codUser, nameText.Text);
                    registerTable.Refresh();
                }
            }
            else
            {
                MessageBox.Show("Por favor, preencha todos os campos corretamente.");
            }
        }


        private void listButton_Click(object sender, EventArgs e)
        {
            try
            {
                using (var connection = Connection.getConnection())
                {
                    connection.Open();
                    string query = "SELECT * FROM cadastros";
                    using (var command = new NpgsqlCommand(query, connection))
                    {
                        using (var reader = command.ExecuteReader())
                        {
                            DataTable tableRegister = new DataTable();
                            tableRegister.Load(reader);
                            registerTable.DataSource = tableRegister;
                            registerTable.Refresh();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erro ao carregar os dados: " + ex.Message);
            }
        }

        private void updateButton_Click(object sender, EventArgs e)
        {
            double codUser;
            double.TryParse(codText.Text, out codUser);
            if (string.IsNullOrWhiteSpace(codText.Text))
            {
                MessageBox.Show("Por favor, informe o código do usuário.");
                return;
            }
            else
            {
                using (var connection = Connection.getConnection())
                {
                    connection.Open();
                    string query = "UPDATE cadastros SET name = @name WHERE coduser = @coduser";
                    using (var command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@coduser", codUser);
                        command.Parameters.AddWithValue("@name", nameText.Text);
                        command.ExecuteNonQuery();
                    }
                    MessageBox.Show("Usuário atualizado com sucesso!");
                    RegistrarLog("UPDATE", codUser, nameText.Text);
                    registerTable.Refresh();
                }
            }
                
        }

        private void deleteButton_Click(object sender, EventArgs e)
        {
            using (var connection = Connection.getConnection())
            {
                double codUser;
                double.TryParse(codText.Text, out codUser);
                connection.Open();
                string query = "DELETE FROM cadastros WHERE coduser = @coduser";
                using (var command = new NpgsqlCommand(query, connection))
                {
                    
                    command.Parameters.AddWithValue("@coduser", codUser);
                    command.ExecuteNonQuery();
                }

                MessageBox.Show("Usuário deletado com sucesso!");
                RegistrarLog("DELETE", codUser, null);
                registerTable.Refresh();

            }
        }

        private void cleanAll_Click(object sender, EventArgs e)
        {
            if(!string.IsNullOrWhiteSpace(nameText.Text) || !string.IsNullOrWhiteSpace(codText.Text))
            {
                nameText.Clear();
                codText.Clear();
            }
            else
            {
                MessageBox.Show("Não há campos para limpar.");
            }
        }

        private void RegistrarLog(string acao, double codUser, string nome)
        {
            using (var connection = Connection.getConnection())
            {
                connection.Open();
                string query = "INSERT INTO logs (acao, coduser, nome) VALUES (@acao, @coduser, @nome)";
                using (var command = new NpgsqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@acao", acao);
                    command.Parameters.AddWithValue("@coduser", codUser);
                    command.Parameters.AddWithValue("@nome", nome ?? (object)DBNull.Value);
                    command.ExecuteNonQuery();
                }
            }
        }

    }
}
