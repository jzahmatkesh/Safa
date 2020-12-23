package tables;

public class TBAccLevel{
    private int cmpid;
    private int id;
    private String name;
    private int active;
    private String token;
    private int autoins;
 
 
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
    public String getName(){
        return name;
    }
    public void setName(String name){
        this.name = name;
    }
    public int getActive(){
        return active;
    }
    public void setActive(int active){
        this.active = active;
    }
    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }
	public int getAutoins() {
		return autoins;
	}
	public void setAutoins(int autoins) {
		this.autoins = autoins;
	}
}