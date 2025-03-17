import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ExportCSVServlet")
public class ExportCSVServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=inventory.csv");
        
        PrintWriter out = response.getWriter();
        out.println("ID,Name,Description,Quantity,Price");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                out.println(rs.getInt("id") + "," +
                            rs.getString("name") + "," +
                            rs.getString("description") + "," +
                            rs.getInt("quantity") + "," +
                            rs.getDouble("price"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
