package tables;

public class TBRegister{
    private String cmpname;
    private String jobtitle;
    private String family;
    private String mobile;
    private String pass;
 
 
    public String getCmpname(){
        return cmpname;
    }
    public void setCmpname(String cmpname){
        this.cmpname = cmpname;
    }
    public String getJobtitle(){
        return jobtitle;
    }
    public void setJobtitle(String jobtitle){
        this.jobtitle = jobtitle;
    }
    public String getFamily(){
        return family;
    }
    public void setFamily(String family){
        this.family = family;
    }
    public String getMobile(){
        return mobile;
    }
    public void setMobile(String mobile){
        this.mobile = mobile;
    }
    public String getPass(){
        return pass;
    }
    public void setPass(String pass){
        this.pass = pass;
    }
}