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

import tables.TBAccGroup;
import tables.TBAccLevel;
import tables.TBImportCoding;
import tables.TBKol;
import tables.TBMoin;
import tables.TBTafsili;
import tables.TBUsers;

@Path("/Coding")
public class Coding {
	private ResultSetToJson tojson = new ResultSetToJson();
	@GET
	@Produces(MediaType.TEXT_HTML+"; charset=UTF-8")
	public Response sayHello()
	{
		return Response.status(405).entity("<img src='../img/403.png' style='position: fixed;top: 50%;left: 50%;margin-top: -170px;margin-left: -310px;'>").build();
	}

	@Path("/Group")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadGroup(TBUsers user, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcAccGroup ?,?,?");
			p.setString(1, user.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
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

	@Path("/Group")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveGroup(TBAccGroup grp, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcSaveAccGroup ?,?,?,?,?");
			p.setString(1, grp.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, grp.getId());
	 		p.setString(5, grp.getName());
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
	
	@Path("/Group")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response delGroup(TBAccGroup grp, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcDelAccGroup ?,?,?,?");
			p.setString(1, grp.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, grp.getId());
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

	
	
	
	@Path("/Kol")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadKol(TBKol kol, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcKol ?,?,?,?,?");
			p.setString(1, kol.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, kol.getGrpid());
	 		p.setString(5, kol.getName());
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
	
	@Path("/Kol")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveKol(TBKol kol, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcSaveKol ?,?,?,?,?,?,?");
			p.setString(1, kol.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, kol.getGrpid());
	 		p.setInt(5, kol.getOld());
	 		p.setInt(6, kol.getId());
	 		p.setString(7, kol.getName());
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
					.entity(tojson.StringToJson("خطا در دریافت اطلاعات از سرور "))
					.build();
		}
	}
	
	@Path("/Kol")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response delKol(TBKol kol, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcDelKol ?,?,?,?");
			p.setString(1, kol.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, kol.getId());
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

	
	@Path("/Moin")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadMoin(TBMoin obj, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcMoin ?,?,?,?,?");
			p.setString(1, obj.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, obj.getKolid());
	 		p.setString(5, obj.getName());
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

	@Path("/Moin")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveMoin(TBMoin moin, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcSaveMoin ?,?,?,?,?,?,?");
			p.setString(1, moin.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, moin.getKolid());
	 		p.setInt(5, moin.getOld());
	 		p.setInt(6, moin.getId());
	 		p.setString(7, moin.getName());
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
					.entity(tojson.StringToJson("خطا در دریافت اطلاعات از سرور "))
					.build();
		}
	}
	
	@Path("/Moin")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response delMoin(TBMoin moin, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcDelMoin ?,?,?,?,?");
			p.setString(1, moin.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, moin.getKolid());
	 		p.setInt(5, moin.getId());
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

	
	
	@Path("/Tafsili")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadTafsili(TBTafsili taf, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcTafsili ?,?,?,?,?");
			p.setString(1, taf.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setString(4, taf.getName());
	 		p.setInt(5, taf.getLevid());
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
					.entity(tojson.StringToJson("خطا در دریافت اطلاعات از سرور"+e.toString()))
					.build();
		}
	}

	@Path("/Tafsili")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveTafsili(TBTafsili obj, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcSaveTafsili ?,?,?,?,?,?");
			p.setString(1, obj.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, obj.getOld());
	 		p.setInt(5, obj.getId());
	 		p.setString(6, obj.getName());
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
					.entity(tojson.StringToJson("خطا در دریافت اطلاعات از سرور "))
					.build();
		}
	}
	
	@Path("/Tafsili")
	@DELETE
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response delTafsili(TBTafsili obj, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcDelTafsili ?,?,?,?");
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

	@Path("/TaftoLevel")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response TafToLevel(TBTafsili obj, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcTafToLevel ?,?,?,?,?");
			p.setString(1, obj.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, obj.getId());
	 		p.setInt(5, obj.getLevid());
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
					.entity(tojson.StringToJson("خطا در دریافت اطلاعات از سرور"+e.toString()))
					.build();
		}
	}


	@Path("/AccLevel")
	@POST
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response loadAccLevel(TBAccLevel obj, @Context HttpServletRequest request)
	{
		JSONArray data = new JSONArray();
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcAccLevel ?,?,?");
			p.setString(1, obj.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
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
	
	@Path("/AccLevel")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response saveAccLevel(TBAccLevel obj, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcSaveAccLevel ?,?,?,?,?,?,?");
			p.setString(1, obj.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, obj.getId());
	 		p.setString(5, obj.getName());
	 		p.setInt(6, obj.getActive());
	 		p.setInt(7, obj.getAutoins());
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

	@Path("/ImportExcel")
	@PUT
	@Produces(MediaType.APPLICATION_JSON+"; charset=UTF-8")
	public Response importtExcel(TBImportCoding imp, @Context HttpServletRequest request)
	{
		try {
			DataBase db = new DataBase();
			Connection con = db.getConnection();
			PreparedStatement p = con.prepareStatement("Exec Fnc.PrcImportCoding ?,?,?,?,?,?,?,?,?");
			p.setString(1, imp.getToken());
	 		p.setString(2, db.GetIPAddress(request));
	 		p.setString(3, db.BrowserInfo(request));
	 		p.setInt(4, imp.getGrpid());
	 		p.setString(5, imp.getGrpname());
	 		p.setInt(6, imp.getKolid());
	 		p.setString(7, imp.getKolname());
	 		p.setInt(8, imp.getMoinid());
	 		p.setString(9, imp.getMoinname());
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
