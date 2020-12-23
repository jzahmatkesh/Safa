package tables;

public class TBTafLevel{
    private int cmpid;
    private int levid;
    private double tafid;
    private String token;
 
 
    public int getCmpid(){
        return cmpid;
    }
    public void setCmpid(int cmpid){
        this.cmpid = cmpid;
    }
    public int getLevid(){
        return levid;
    }
    public void setLevid(int levid){
        this.levid = levid;
    }
    public double getTafid(){
        return tafid;
    }
    public void setTafid(double tafid){
        this.tafid = tafid;
    }
    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }
}