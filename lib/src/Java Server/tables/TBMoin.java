package tables;

public class TBMoin{
    private int cmpid;
    private int kolid;
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
    public int getKolid(){
        return kolid;
    }
    public void setKolid(int kolid){
        this.kolid = kolid;
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