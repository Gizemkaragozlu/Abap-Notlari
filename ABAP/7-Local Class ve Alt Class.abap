class math_op definition. "kullanılcak data veya methodlar definition alanında verilir.

	public section.//erişilebilirlik turu
		data: lv_num1 type i,
			  lv_num2 type,
			  rv_result type i.
	
	methods: sum_Numbers."Methodlar

endclass.

class math_op implementation."data ve method kodlaması yapılır
	method sum_Numbers.
		lv_result = lv_num1 + lv_num2."Public olarak istenen parametreler 
	endmethod.
endclass.


"Alt class oluşturma
"Kalıtım alma işlemi yapılır
"class class_adi definition inheritin from kalıtım_alıncak_class_adi
class math_op_diff definetion inheriting from math_op.
	public section.
		mehods numb_diff."Kalıtım aldıgımız için tekrardan degisken oluşturmaya gerek yoktur onceki classın degiskenlerini kullanabiliriz
endclass.

class math_op_diff implementation."Classı doldurmak işlevsel hale getirmek
	method numb_diff."Classın methodunu doldururuz
		lv_result = lv_num1 - lv_num2."Kalıtım aldıgımız degiskenleri kullanırız
	endmethod.
endclass.


"oluşturulan classı kullanma

"iki adet degisken ve iki classımızı referan verdik
data: go_math_op type ref to math_op.
	go_math_op_diff type ref to math_op_diff.

start-of-selection."programın başlamasıyla
	create object: go_math_op."2 objemizi de yarattık
	create object: go_math_op_diff.

	go_math_op->lv_num1 = 10."Ilk degisken yani klassımzıın parametrelerini verdik
	go_math_op->lv_num2 = 30.
	go_math_op->sum_Numbers()."Methodumuzu calıştırdık

	write: go_math_op->lv_result."write komutu ile class içindeki public olan sonuc degiskenimizi yazdırdık
	
	go_math_op_diff->lv_num1=10."Aynı işlemleri 2.class içinde kullandık
	go_math_op_diff->lv_num2=90.
	go_math_op_diff->numb_diff().
	write: go_math_op_diff->lv_result.
	


"Encapsullation "Erişilebilirlik sınırlama

class enc_op definition.
	public section."Public heryerden erişilebilir
		data: lv_ad type string.
			lv_soyad type string.
			
	protected section."Sadece kalıtım alan ve bu classta kullanılabilir
		data: lv_babaAd type string.
	
	private section."Sadece bu classta kullanılabilir
		data:lv_yas type int.
		
