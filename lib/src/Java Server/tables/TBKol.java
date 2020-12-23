package tables;

public class TBKol{
    private int cmpid;
    private int grpid;
    private int old;
    private int id;
    private String name;
    private String token;
 
 
    public int getCmpid(){
        return cmpid;
    }
    public void setCmpid(int cmpid){
        this.cmpid = cmpid;
    }
    public int getGrpid(){
        return grpid;
    }
    public void setGrpid(int grpid){
        this.grpid = grpid;
    }
    public int getId(){
        return id;
    }
    public void setId(int id){
        this.id = id;
    }
    public String getName(){
        return name;
    }
    public void setName(String name){
        this.name = name;
    }
    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }
	public int getOld() {
		return old;
	}
	public void setOld(int old) {
		this.old = old;
	}
}