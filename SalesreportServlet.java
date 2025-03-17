@WebServlet("/SalesReportServlet")
public class SalesReportServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT name, SUM(quantity) AS total_sold FROM sales GROUP BY name")) {
            
            ResultSet rs = stmt.executeQuery();
            out.print("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) out.print(",");
                out.print("{\"product\":\"" + rs.getString("name") + "\",\"sales\":" + rs.getInt("total_sold") + "}");
                first = false;
            }
            out.print("]");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
