import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletResponse;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

@WebServlet("/ExportPDFServlet")
public class ExportPDFServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=inventory.pdf");

        try (OutputStream out = response.getOutputStream();
             Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products");
             ResultSet rs = stmt.executeQuery()) {

            Document document = new Document();
            PdfWriter.getInstance(document, out);
            document.open();
            document.add(new Paragraph("Inventory Report\n\n"));

            PdfPTable table = new PdfPTable(5);
            table.addCell("ID");
            table.addCell("Name");
            table.addCell("Description");
            table.addCell("Quantity");
            table.addCell("Price");

            while (rs.next()) {
                table.addCell(String.valueOf(rs.getInt("id")));
                table.addCell(rs.getString("name"));
                table.addCell(rs.getString("description"));
                table.addCell(String.valueOf(rs.getInt("quantity")));
                table.addCell("$" + rs.getDouble("price"));
            }

            document.add(table);
            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
