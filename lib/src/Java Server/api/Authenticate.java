package api;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.mashape.unirest.http.HttpResponse;
import com.mashape.unirest.http.JsonNode;
import com.mashape.unirest.http.Unirest;

//import org.json.JSONArray;
//import org.json.JSONObject;
//
//import com.mashape.unirest.http.HttpResponse;
//import com.mashape.unirest.http.Unirest;

import tables.TBRegister;
import tables.TBUsers;


@Path("/User")
public class Authenticate {
	private ResultSetToJson tojson = new ResultSetToJson();
	@GET
	@Produces(MediaType.TEXT_HTML+"; charset=UTF-8")
	public Response sayHello()
	{
		return Response.status(405).entity("<img src='../img/403.png' style='position: fixed;top: 50%;left: 50%;margin-top: -170px;margin-left: -310px;'>").build();
	}

	@Path("/Authenticate")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response authenticate(TBUsers user, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcAuthenticate ?,?,?,?");
	 		p.setString(1, db.GetIPAddress(request));
	 		p.setString(2, db.BrowserInfo(request));
	 		p.setString(3, user.getMobile());
	 		p.setString(4, user.getPass());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success"))
					return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();
				else 
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(tojson.ResultsetToJson(rs))
							.build();
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity(tojson.StringToJson("جوابی از سرور دریافت نشد"))
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity(tojson.StringToJson("خطا در دریافت اطلاعات از سرور"))
					.build();
		}
	}

	@Path("/Verify")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response verify(TBUsers user, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcToken_Authenticate ?,?,?");
	 		p.setString(1, db.GetIPAddress(request));
	 		p.setString(2, db.BrowserInfo(request));
	 		p.setString(3, user.getToken());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success"))
					return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();
				else 
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(tojson.ResultsetToJson(rs))
							.build();
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity(tojson.StringToJson("جوابی از سرور دریافت نشد"))
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity(tojson.StringToJson("خطا در دریافت اطلاعات از سرور"+e.toString()))
					.build();
		}
	}

	@Path("/Register")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response register(TBRegister reg, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcRegister ?,?,?,?,?,?,?");
			p.setString(1, db.GetIPAddress(request));
	 		p.setString(2, db.BrowserInfo(request));
	 		p.setString(3, reg.getCmpname());
	 		p.setString(4, reg.getJobtitle());
	 		p.setString(5, reg.getFamily());
	 		p.setString(6, reg.getMobile());
	 		p.setString(7, reg.getPass());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")) {
					return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();
				}
				else { 
					return Response
							.status(Response.Status.UNAUTHORIZED)
							.entity(tojson.ResultsetToJson(rs))
							.build();
				}
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity(tojson.StringToJson("جوابی از سرور دریافت نشد"))
					.build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity(tojson.StringToJson("خطا در دریافت اطلاعات از سرور "+e.toString()))
					.build();
		}
	}

		
	@Path("/SMS")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response sendSms(TBUsers user, @Context HttpServletRequest request)
	{
		try {
//			application/x-www-form-urlencoded
			HttpResponse<String> response = Unirest.post("http://api.ghasedaksms.com/v2/sms/send/simple ")
					.header("apikey", "r8b0aNj74Yk1SzoTKFik422ggC2C8G+Us9p+/QYNlFI")
					.header("content-type", "application/x-www-form-urlencoded")
					.body("message="+user.getFamily()+"&sender=3000500222&Receptor="+user.getMobile()+"&=")
					.asString();
			return Response.ok(response.getBody(), MediaType.APPLICATION_JSON).build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity(tojson.StringToJson("خطا در ارسال پیامک"))
					.build();
		}
	}
	
	public static String getRandomNumberString() {
	    // It will generate 6 digit random Number.
	    // from 0 to 999999
	    Random rnd = new Random();
	    int number = rnd.nextInt(999999);

	    // this will convert any number sequence into 6 character.
	    return String.format("%06d", number);
	}
	
}
