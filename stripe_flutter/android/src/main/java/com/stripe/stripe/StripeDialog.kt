package com.stripe.stripe

import android.os.Bundle
import android.support.design.widget.Snackbar
import android.support.v4.app.DialogFragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.stripe.android.SourceCallback
import com.stripe.android.Stripe
import com.stripe.android.model.Source
import com.stripe.android.model.SourceParams
import com.stripe.android.view.CardMultilineWidget
import java.lang.Exception
import com.stripe.android.model.Card
import android.src.main.java.com.stripe.stripe.CardPaymen



class StripeDialog : DialogFragment() {

    companion object {
        fun newInstance(title: String, publishableKey: String): StripeDialog {
            val frag = StripeDialog()
            val args = Bundle()
            args.putString("title", title)
            args.putString("publishableKey", publishableKey)
            frag.arguments = args
            return frag
        }

    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        return inflater!!.inflate(R.layout.activity_stripe, container)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        // Get field from view
        // Fetch arguments from bundle and set title
        val title = arguments?.getString("title", "Add Source")
        dialog.setTitle(title)

        view?.findViewById<View>(R.id.buttonSave)?.setOnClickListener {
            getToken()
        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState)

        setStyle(DialogFragment.STYLE_NO_TITLE, R.style.Theme_AppCompat_Light_Dialog)
    }
    var tokenListener: ((String) -> (Unit))? = null

    private fun getToken() {
        val mCardInputWidget = view?.findViewById<View>(R.id.card_input_widget) as CardMultilineWidget
        val cardToSave = mCardInputWidget.getCard()
        print(cardToSave)
        if (mCardInputWidget.validateAllFields()) {

            mCardInputWidget.card?.let { card ->
                val resultat = card.number+"/"+""+card.expMonth!!+"/"+card.expYear!!+"/"+card.cvc
                view?.findViewById<View>(R.id.progress)?.visibility = View.VISIBLE
                view?.findViewById<View>(R.id.buttonSave)?.visibility = View.GONE

                tokenListener?.invoke(resultat.toString())
                dismiss()
            }
        }
        else {
            view?.let {
                Snackbar.make(it, "The card info you entered is not correct", Snackbar.LENGTH_LONG).show()
            }
        }

    }
}
