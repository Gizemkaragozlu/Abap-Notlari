se38 ile program oluşturulur
////////////////////
///Class oluturma///
////////////////////
class math_op definition. //kullanılcak data veya methodlar tanımlanmır.

	public section.//erişilebilirlik turu
		data: lv_num1 type i,
			  lv_num2 type,
			  rv_result type i.
	
	methods: sum_Numbers.

endclass.

class math_op implementation.//data ve method kodlaması yapılır
	method sum_Numbers.
		lv_result = lv_num1 + lv_num2.
	endmethod.
endclass.

//////////////////////
Alt class oluşturma///
//////////////////////
Kalıtım alma değişkenleri kalıtım alır
class math_op_diff definetion inheriting from math_op.
	public section.
		mehods numb_diff.
endclass.

class math_op_diff implementation.
	method numb_diff.
		lv_result = lv_num1 - lv_num2.
	endmethod.
endclass.


/////////////////////////////
oluşturulan classı kullanma//
/////////////////////////////

data: go_math_op type ref to math_op.
	go_math_op_diff type ref to math_op_diff.

start-of-selection.
	create object: go_math_op.
	create object: go_math_op_diff.

	go_math_op->lv_num1 = 10.
	go_math_op->lv_num2 = 30.
	go_math_op->sum_Numbers().

	write: go_math_op->lv_result.
	
	go_math_op_diff->lv_num1=10.
	go_math_op_diff->lv_num2=90.
	go_math_op_diff->numb_diff().
	write: go_math_op_diff->lv_result.
	

//////////////////
Encapsullation////
//////////////////

class enc_op definition.
	public section.
		data: lv_ad type string.
			lv_soyad type string.
			
	protected section.
		data: lv_babaAd type string.
	
	private section.
		data:lv_yas type int.
		
