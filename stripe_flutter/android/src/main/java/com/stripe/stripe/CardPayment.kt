package android.src.main.java.com.stripe.stripe;


class CardPaymen {
   private var  number :String;
    private var  expireDay :Int;
    private var  expireYear :Int;
    private var  code :String;

     constructor(number: String ,expireDay: Int ,expireYear: Int ,code: String ) {
        this.number = number;
        this.expireDay = expireDay;
        this.expireYear = expireYear;
        this.code   = code;
    }

    override fun toString(): String {
        return super.toString()
    }
}
