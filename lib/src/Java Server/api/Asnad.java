package api;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.JSONArray;

import tables.TBArtykl;
import tables.TBSanad;

@Path("/Asnad")
public class Asnad {
	private ResultSetToJson tojson = new ResultSetToJson();
	@GET
	@Produces(MediaType.TEXT_HTML+"; charset=UTF-8")
	public Response sayHello()
	{
		return Response.status(405).entity("<img src='../img/403.png' style='position: fixed;top: 50%;left: 50%;margin-top: -170px;margin-left: -310px;'>").build();
	}

	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadAsnad(TBSanad obj, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcASnad ?,?,?,?");
			p.setString(1, obj.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, obj.getFilter());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (!db.CheckStrFieldValue(rs, "Msg").equals("Failed")){
						data.put(tojson.ResultsetToJson(rs));
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(tojson.ResultsetToJson(rs))
								.build();
					}
			}
			return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity(tojson.StringToJson("خطا در دریافت اطلاعات از سرور"))
					.build();
		}
	}
	
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response delSanad(TBSanad obj, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcDelSanad ?,?,?,?");
			p.setString(1, obj.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, obj.getId());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
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
					.entity(tojson.StringToJson("خطا در دریافت اطلاعات از سرور"))
					.build();
		}
	}

	@Path("/Reg")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response setSanadReg(TBSanad obj, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcSetSanadReg ?,?,?,?");
			p.setString(1, obj.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, obj.getId());
	 		java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
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
					.entity(tojson.StringToJson("خطا در دریافت اطلاعات از سرور"))
					.build();
		}
	}
	
	@Path("/NewSanad")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response newSanad(TBSanad obj, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcNewSanad ?,?,?");
			p.setString(1, obj.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (!db.CheckStrFieldValue(rs, "Msg").equals("Failed")){
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
					.entity("خطا در دریافت اطلاعات از سرور")
					.build();
		}
	}
	
	@Path("/Copy")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response copySanad(TBSanad obj, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcCopySanad ?,?,?,?");
			p.setString(1, obj.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, obj.getId());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (!db.CheckStrFieldValue(rs, "Msg").equals("Failed")){
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
					.entity(tojson.StringToJson("خطا در دریافت اطلاعات از سرور"))
					.build();
		}
	}

	@Path("/Artykl")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadSanadArtykl(TBSanad obj, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcASnadArtykl ?,?,?,?");
			p.setString(1, obj.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, obj.getId());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null){
				while(rs.next())
					if (!db.CheckStrFieldValue(rs, "Msg").equals("Failed")){
						data.put(tojson.ResultsetToJson(rs));
					}
					else {
						return Response
								.status(Response.Status.UNAUTHORIZED)
								.entity(tojson.ResultsetToJson(rs))
								.build();
					}
			}
			return Response.ok(data.toString(), MediaType.APPLICATION_JSON).build();
		}
		catch(Exception e) {
			return Response
					.status(Response.Status.FORBIDDEN)
					.entity(tojson.StringToJson("خطا در دریافت اطلاعات از سرور"))
					.build();
		}
	}

	@Path("/Sanad")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveSanad(TBSanad obj, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcSaveSanad ?,?,?,?,?,?,?");
			p.setString(1, obj.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, obj.getOld());
	 		p.setInt(5, obj.getId());
	 		p.setString(6, obj.getDate());
	 		p.setString(7, obj.getNote());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
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
					.entity(tojson.StringToJson("خطا در دریافت اطلاعات از سرور"))
					.build();
		}
	}
	
	@Path("/Artykl")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveArtykl(TBArtykl obj, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcSaveArtykl ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?");
			p.setString(1, obj.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, obj.getSanadid());
	 		p.setInt(5, obj.getId());
	 		p.setInt(6, obj.getKolid());
	 		p.setInt(7, obj.getMoinid());
	 		p.setInt(8, obj.getTaf1());
	 		p.setInt(9, obj.getTaf2());
	 		p.setInt(10, obj.getTaf3());
	 		p.setInt(11, obj.getTaf4());
	 		p.setInt(12, obj.getTaf5());
	 		p.setInt(13, obj.getTaf6());
	 		p.setString(14, obj.getNote());
	 		p.setDouble(15, obj.getBed());
	 		p.setDouble(16, obj.getBes());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
					return Response.ok(tojson.ResultsetToJson(rs), MediaType.APPLICATION_JSON).build();
				}
				else {
					return Response
							.status(Response.Status.UNAUTHORIZED)
//							.entity(db.CheckStrFieldValue(rs, "Msg"))
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
					.entity(tojson.StringToJson("خطا در دریافت اطلاعات از سرور"))
					.build();
		}
	}

	@Path("/Artykl")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response delArtykl(TBArtykl obj, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcDelArtykl ?,?,?,?,?");
			p.setString(1, obj.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, obj.getSanadid());
	 		p.setInt(5, obj.getId());
			java.sql.ResultSet rs = p.executeQuery();
			if (rs != null && rs.next())
				if (db.CheckStrFieldValue(rs, "Msg").equals("Success")){
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
					.entity(tojson.StringToJson("خطا در دریافت اطلاعات از سرور"))
					.build();
		}
	}
}
