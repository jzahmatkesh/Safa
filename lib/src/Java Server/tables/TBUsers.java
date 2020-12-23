package tables;

public class TBUsers{
    private int cmpid;
    private int id;
    private String family;
    private int admin;
    private String mobile;
    private String email;
    private String pass;
    private String tel;
    private String semat;
    private String token;
 
 
    public int getCmpid(){
        return cmpid;
    }
    public void setCmpid(int cmpid){
        this.cmpid = cmpid;
    }
    public int getId(){
        return id;
    }
    public void setId(int id){
        this.id = id;
    }
    public String getFamily(){
        return family;
    }
    public void setFamily(String family){
        this.family = family;
    }
    public int getAdmin(){
        return admin;
    }
    public void setAdmin(int admin){
        this.admin = admin;
    }
    public String getMobile(){
        return mobile;
    }
    public void setMobile(String mobile){
        this.mobile = mobile;
    }
    public String getEmail(){
        return email;
    }
    public void setEmail(String email){
        this.email = email;
    }
    public String getTel(){
        return tel;
    }
    public void setTel(String tel){
        this.tel = tel;
    }
    public String getSemat(){
        return semat;
    }
    public void setSemat(String semat){
        this.semat = semat;
    }
    public String getToken(){
        return token;
    }
    public void setToken(String token){
        this.token = token;
    }
	public String getPass() {
		return pass;
	}
	public void setPass(String pass) {
		this.pass = pass;
	}
}