class_name WeightedTable

var items : Array[Dictionary] = []
var weight_sum = 0


func add_item(item, weight : int):
	items.append({ "item" : item, "weight" : weight })
	weight_sum += weight


func pick_item():
	var chosen_weight = randi_range(1, weight_sum)
	var iteration_sum = 0   # 改成局部变量，每次调用都重新从0开始
	
	for item in items:
		iteration_sum += item["weight"]
		
		if chosen_weight <= iteration_sum:
			return item["item"]
	
	return null  # 保险起见加个兜底返回值
