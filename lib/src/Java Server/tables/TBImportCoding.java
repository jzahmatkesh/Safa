package tables;

public class TBImportCoding{
    private int grpid;
    private String grpname;
    private int kolid;
    private String kolname;
    private int moinid;
    private String moinname;
    private String token;
 
 
    public int getGrpid(){
        return grpid;
    }
    public void setGrpid(int grpid){
        this.grpid = grpid;
    }
    public String getGrpname(){
        return grpname;
    }
    public void setGrpname(String grpname){
        this.grpname = grpname;
    }
    public int getKolid(){
        return kolid;
    }
    public void setKolid(int kolid){
        this.kolid = kolid;
    }
    public String getKolname(){
        return kolname;
    }
    public void setKolname(String kolname){
        this.kolname = kolname;
    }
    public int getMoinid(){
        return moinid;
    }
    public void setMoinid(int moinid){
        this.moinid = moinid;
    }
    public String getMoinname(){
        return moinname;
    }
    public void setMoinname(String moinname){
        this.moinname = moinname;
    }
    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }
}