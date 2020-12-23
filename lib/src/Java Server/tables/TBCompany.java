package tables;

public class TBCompany{
    private int id;
    private String name;
    private String jobtitle;
    private String ceo;
    private String tel;
    private String mobile;
    private String address;
    private String token;
 
 
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
    public String getJobtitle(){
        return jobtitle;
    }
    public void setJobtitle(String jobtitle){
        this.jobtitle = jobtitle;
    }
    public String getCeo(){
        return ceo;
    }
    public void setCeo(String ceo){
        this.ceo = ceo;
    }
    public String getTel(){
        return tel;
    }
    public void setTel(String tel){
        this.tel = tel;
    }
    public String getMobile(){
        return mobile;
    }
    public void setMobile(String mobile){
        this.mobile = mobile;
    }
    public String getAddress(){
        return address;
    }
    public void setAddress(String address){
        this.address = address;
    }
    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }
}