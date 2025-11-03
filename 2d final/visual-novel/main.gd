extends CanvasLayer

# =============================
# 信号：场景切换
# =============================
signal change_scene(scene_id: String)

# -----------------------------
# 节点引用
# -----------------------------
@onready var text: Label = %Text
@onready var npc_name_text: Label = %npc_name_text

@onready var buttonlist: VBoxContainer = $Control/buttonlist

# -----------------------------
# 对话系统变量
# -----------------------------
var scenes := {}				# 所有场景：{ scene_id: { node_key: {npc,text,options/next/response} } }
var scene_order := []			# 场景顺序
var current_scene_id := ""
var dialogue := {}				# 当前场景节点字典
var current_node := ""
var awaiting_choice := false

func _ready():
	load_all_scenes()
	# 开始于文档开场场景 S1_Tickets（Conductor: Tickets?）
	start_scene("S1_Tickets", "Tickets?")

# =========================================================
# 加载全部场景（按文档拆分为多段）
# =========================================================
func load_all_scenes() -> void:
	scenes.clear()
	scene_order.clear()

	# ---------- S1：Tickets 开场 ----------
	scenes["S1_Tickets"] = {
		"Tickets?": {
			"npc": "Conductor",
			"text": "Tickets?",
			"options": [
				{"text": "Huh?", "next": "Your tickets."},
				{"text": "Oh, uh, let me find it…", "next": "FindTicket"}
			]
		},
		"Your tickets.": {
			"npc": "Conductor",
			"text": "Your tickets.",
			"options": [
				{"text": "What tickets?", "next": "Do you know where you’re going?"},
				{"text": "Oh, uh, let me find it…", "next": "FindTicket"}
			]
		},
		"FindTicket": {
			"npc": "Conductor",
			"text": "Take your time.",
			"response": "You can’t find your ticket.\nYou\n: I can’t find it.",
			"next": "Do you know where you’re going?"
		},
		"Do you know where you’re going?": {
			"npc": "Conductor",
			"text": "Do you know where you’re going?",
			"options": [
				{"text": "No…", "next": "Do you know how you got on this train?"},
				{"text": "Whatever way the train is going.", "next": "Angry"}
			]
		},
		"Do you know how you got on this train?": {
			"npc": "Conductor",
			"text": "Do you know how you got on this train?",
			"options": [
				{"text": "Walking, probably.", "next": "GirlRun"},
				{"text": "No sir.", "next": "GirlRun"}
			]
		},
		"Angry": {
			"npc": "Conductor",
			"text": "Don’t play smart with me. Get off my train."
		},
		"GirlRun": {
			"npc": "System",
			"text": "A little girl runs past.",
			"next": "Chase"
		},
		"Chase": {
			"npc": "Conductor",
			"text": "Ah, sh- I’ll be back. You better find yourself a ticket, okay?"
		}
	}

	# ---------- S2：Greed & Charity 片段 ----------
	scenes["S2_GreedCharity"] = {
		"Greet": {
			"npc": "Greed",
			"text": "Oh, good, someone's here... You wanna buy some of my crypto? I can sell it to you, if you want.",
			"options": [
				{"text": "Uh, no thanks.", "next": "WhoAreYou"},
				{"text": "Sure.", "next": "WhatHaveYouGot"}
			]
		},
		"WhatHaveYouGot": {
			"npc": "Greed",
			"text": "Great! What have you got to give me?",
			"options": [
				{"text": "Uh…", "next": "GreedTypical"},
				{"text": "Doesn’t look like I have anything…", "next": "GreedTypical"}
			]
		},
		"GreedTypical": {
			"npc": "Greed",
			"text": "Pshh… Typical… People just wanna take and take...",
			"next": "WhoAreYou"
		},
		"WhoAreYou": {
			"npc": "Greed",
			"text": "My name don't matter… do you think you're smart?",
			"options": [
				{"text": "I guess so.", "next": "Pitch"},
				{"text": "Probably not.", "next": "Pitch"}
			]
		},
		"Pitch": {
			"npc": "Greed",
			"text": "I run a business… you sell products, recruit others… give me a cut. That's how business works.",
			"options": [
				{"text": "Isn't that an MLM?", "next": "GreedRambling"},
				{"text": "No thanks.", "next": "GreedRambling"}
			]
		},
		"GreedRambling": {
			"npc": "System",
			"text": "Greed continues rambling about the amazing opportunity.",
			"next": "BreadAppears"
		},
		"BreadAppears": {
			"npc": "System",
			"text": "A loaf of bread appears in your hands.",
			"next": "CharityAsk"
		},
		"CharityAsk": {
			"npc": "Charity",
			"text": "Bread… Could I maybe have a piece?",
			"options": [
				{"text": "Oh, uh, no…", "next": "GreedSnatch"},
				{"text": "Give bread", "next": "CharityThank"}
			]
		},
		"GreedSnatch": {
			"npc": "System",
			"text": "Greed grabs the bread and swallows it down.",
			"options": [
				{"text": "Uh - Hey!", "next": "ItsNotOkay"},
				{"text": "Say nothing", "next": "ItsOkay"}
			]
		},
		"CharityThank": {
			"npc": "Charity",
			"text": "[She takes the bread.] Thank you, sir.",
			"next": "GreedGrabAnyway"
		},
		"GreedGrabAnyway": {
			"npc": "System",
			"text": "Greed snatches the bread and swallows it down.",
			"next": "HeyIGave"
		},
		"HeyIGave": {
			"npc": "You",
			"text": "Hey, I gave that to her! Not you!",
			"next": "ItsOkay"
		},
		"ItsOkay": {
			"npc": "Charity",
			"text": "It's okay.",
			"options": [
				{"text": "Okay…", "next": "BusinessAgain"},
				{"text": "No it's not.", "next": "BusinessAgain"}
			]
		},
		"ItsNotOkay": {
			"npc": "You",
			"text": "Hey!",
			"next": "BusinessAgain"
		},
		"BusinessAgain": {
			"npc": "Greed",
			"text": "So do you want in on my business or not?",
			"options": [
				{"text": "You're still talking about that?", "next": "GreedStill"},
				{"text": "She's not your kid? Whose kid is this?", "next": "WhoseKid"}
			]
		},
		"GreedStill": {
			"npc": "Greed",
			"text": "Of course! This is my money—my business!",
			"next": "OfferKid"
		},
		"WhoseKid": {
			"npc": "Greed",
			"text": "What's it matter? If you're so obsessed with her, I'll give her to ya then! But what have you got for me?",
			"options": [
				{"text": "So you don't know this kid?", "next": "OfferKid"},
				{"text": "Hey, kid, do you know this man?", "next": "OfferKid"}
			]
		},
		"OfferKid": {
			"npc": "Greed",
			"text": "You want the kid or not?",
			"options": [
				{"text": "I don't think that's a good idea…", "next": "GreedLeaves"},
				{"text": "Fine, leave her with me. I'll keep her safe.", "next": "CharitySitsHere"}
			]
		},
		"GreedLeaves": {
			"npc": "System",
			"text": "Greed leaves, grumbling. [End of section.]"
		},
		"CharitySitsHere": {
			"npc": "System",
			"text": "[Greed leaves.] Charity sits beside you."
		}
	}

	# ---------- S3：They Leave / Conductor 回来 ----------
	scenes["S3_TheyLeave"] = {
		"Return": {
			"npc": "Conductor",
			"text": "Oh, right, I forgot about you. Did you manage to figure out your ticket situation?",
			"options": [
				{"text": "No, sir, I'm sorry—", "next": "SoNoTickets"},
				{"text": "I completely forgot—There was this weird guy—", "next": "SoNoTickets"}
			]
		},
		"SoNoTickets": {
			"npc": "Conductor",
			"text": "So no tickets?",
			"options": [
				{"text": "No, sir.", "next": "DoYouExpect"}
			]
		},
		"DoYouExpect": {
			"npc": "Conductor",
			"text": "And do you expect me to keep you on this train with no ticket?",
			"options": [
				{"text": "No, sir. I'll leave.", "next": "End_GaveUp"},
				{"text": "I don't think I need a ticket.", "next": "End_GaveUp"},
				{"text": "I don't expect it, but I am hoping you will let me stay.", "next": "WhyStay"}
			]
		},
		"End_GaveUp": {
			"npc": "System",
			"text": "[You got this far and gave up?]"
		},
		"WhyStay": {
			"npc": "Conductor",
			"text": "And why's that?",
			"response": "Because I don't know where I am going, but I feel like I need to get there.",
			"next": "GirlRunsAgain"
		},
		"GirlRunsAgain": {
			"npc": "System",
			"text": "The little girl runs by again. Conductor jumps up.",
			"next": "Lucky"
		},
		"Lucky": {
			"npc": "Conductor",
			"text": "You're lucky. I'll be back."
		}
	}

	# ---------- S4：Trust W/O Charity ----------
	scenes["S4_TrustNoCharity"] = {
		"Hide": {
			"npc": "System",
			"text": "The little girl stops and hides behind a pole.",
			"options": [
				{"text": "Where are your parents? Let me call the conductor—", "next": "DartAway_End"},
				{"text": "Give a small smile, but say nothing.", "next": "Stare"},
				{"text": "Hey kid, you okay?", "next": "DartAway_End"}
			]
		},
		"DartAway_End": {
			"npc": "System",
			"text": "The little girl darts away."
		},
		"Stare": {
			"npc": "System",
			"text": "The little girl inches away from the pole to get a better look at you.",
			"options": [
				{"text": "I'll be sitting here for a while. Feel free to join me.", "next": "EyesDart"},
				{"text": "What's your name?", "next": "DartAway_End"}
			]
		},
		"EyesDart": {
			"npc": "System",
			"text": "Her eyes dart between you and the empty seat.",
			"options": [
				{"text": "My name is… I can't… I don't know…", "next": "Relax"},
				{"text": "Stay quiet.", "next": "Relax"}
			]
		},
		"Relax": {
			"npc": "System",
			"text": "The little girl relaxes her shoulders.",
			"options": [
				{"text": "Do you know where we're headed?", "next": "ShakeNo"}
			]
		},
		"ShakeNo": {
			"npc": "System",
			"text": "The little girl shakes her head no.",
			"response": "That makes two of us.",
			"next": "SitDown"
		},
		"SitDown": {
			"npc": "System",
			"text": "The little girl sits down."
		}
	}

	# ---------- S5：Charity Sits ----------
	scenes["S5_CharitySits"] = {
		"Start": {
			"npc": "Charity",
			"text": "Thank you.",
			"options": [
				{"text": "Of course.", "next": "Silence"},
				{"text": "Stay silent.", "next": "Silence"}
			]
		},
		"Silence": {
			"npc": "System",
			"text": "Silence falls between you two. The little girl runs by… followed by the conductor.",
			"next": "AskTickets"
		},
		"AskTickets": {
			"npc": "Conductor",
			"text": "Oh, right, I forgot about you. Did you manage to figure out your ticket situation?",
			"options": [
				{"text": "No, sir, I'm sorry—", "next": "SoNoTickets"},
				{"text": "I completely forgot—See, there was this weird guy—", "next": "SoNoTickets"}
			]
		},
		"SoNoTickets": {
			"npc": "Conductor",
			"text": "So no tickets?",
			"options": [
				{"text": "No, sir.", "next": "DoYouExpect"}
			]
		},
		"DoYouExpect": {
			"npc": "Conductor",
			"text": "And do you expect me to keep you on this train with no ticket?",
			"options": [
				{"text": "No, sir. I'll leave.", "next": "End_GaveUp"},
				{"text": "I don't think I need a ticket.", "next": "End_GaveUp"},
				{"text": "I don't expect it, but I am hoping you will let me stay.", "next": "WhyStay"}
			]
		},
		"End_GaveUp": {
			"npc": "System",
			"text": "[You got this far and gave up?]"
		},
		"WhyStay": {
			"npc": "Conductor",
			"text": "And why's that?",
			"options": [
				{"text": "Because I don't know where I am going, but I feel like I need to get there.", "next": "LuckyBranch"},
				{"text": "Because a strange man just abandoned this little girl, and now I am trying to get her somewhere safe.", "next": "TicketTwist"}
			]
		},
		"LuckyBranch": {
			"npc": "System",
			"text": "The little girl runs by again. Conductor jumps up.",
			"next": "Lucky"
		},
		"Lucky": {
			"npc": "Conductor",
			"text": "You're lucky. I'll be back."
		},
		"TicketTwist": {
			"npc": "System",
			"text": "Charity holds out a torn piece of paper.",
			"next": "TicketCheck"
		},
		"TicketCheck": {
			"npc": "Conductor",
			"text": "What's this? A ticket? Well, kids don't need tickets. Where'd you get this?",
			"response": "Charity: Someone stole it for me.",
			"next": "LuckyStay"
		},
		"LuckyStay": {
			"npc": "Conductor",
			"text": "Ah, well… Looks like your lucky day. Here's your ticket. You can stay after all."
		}
	}

	# ---------- S6：Trust with Charity ----------
	scenes["S6_TrustWithCharity"] = {
		"Hide": {
			"npc": "System",
			"text": "The little girl stops and hides behind a pole.",
			"options": [
				{"text": "Where are your parents? Let me call the conductor—", "next": "DartAway_End"},
				{"text": "Give a small smile, but say nothing.", "next": "Stare"},
				{"text": "Hey kid, you okay?", "next": "HugCat"}
			]
		},
		"DartAway_End": {
			"npc": "System",
			"text": "The little girl darts away."
		},
		"Stare": {
			"npc": "System",
			"text": "The little girl stares at you with unblinking curiosity.",
			"options": [
				{"text": "We're gonna be sitting here for a while. Feel free to join us.", "next": "EyesDart"},
				{"text": "What's your name?", "next": "ShakeNoDisapprove"}
			]
		},
		"HugCat": {
			"npc": "System",
			"text": "The little girl adjusts her hood and hugs her toy cat closer.",
			"next": "Intro"
		},
		"EyesDart": {
			"npc": "System",
			"text": "Her eyes dart between you and the other little girl.",
			"next": "Intro"
		},
		"ShakeNoDisapprove": {
			"npc": "System",
			"text": "The little girl shakes her head disapprovingly.",
			"next": "Intro"
		},
		"Intro": {
			"npc": "You",
			"text": "My name is… I can't… I don't know…",
			"response": "Charity: That's quite common.",
			"options": [
				{"text": "Do you know where we're headed?", "next": "AskHeaded"}
			]
		},
		"AskHeaded": {
			"npc": "System",
			"text": "The little girl shakes her head no.",
			"options": [
				{"text": "No…", "next": "SitDown"},
				{"text": "Yes.", "next": "GoodOrBad"},
				{"text": "I don't know.", "next": "CommonCommon"}
			]
		},
		"SitDown": {
			"npc": "System",
			"text": "The little girl sits down."
		},
		"GoodOrBad": {
			"npc": "Charity",
			"text": "Is it good or bad?",
			"options": [
				{"text": "Good, I think.", "next": "EveryoneThinks"},
				{"text": "Bad, I think.", "next": "Unfortunate"},
				{"text": "I don't know.", "next": "CommonCommon"}
			]
		},
		"EveryoneThinks": {
			"npc": "Charity",
			"text": "That's what everyone thinks."
		},
		"Unfortunate": {
			"npc": "Charity",
			"text": "Unfortunate."
		},
		"CommonCommon": {
			"npc": "Charity",
			"text": "That's quite common. Quite common…",
			"next": "SitDown"
		}
	}

	# 线性顺序（基础路径）
	scene_order = ["S1_Tickets", "S2_GreedCharity", "S3_TheyLeave", "S4_TrustNoCharity", "S5_CharitySits", "S6_TrustWithCharity"]

# =========================================================
# 启动/切换 场景 & 节点
# =========================================================
func start_scene(scene_id: String, start_node: String) -> void:
	if not scenes.has(scene_id):
		printerr("Missing scene: ", scene_id)
		return
	current_scene_id = scene_id
	dialogue = scenes[scene_id]
	emit_signal("change_scene", current_scene_id)	# ✨ 场景切换信号
	start_dialogue(start_node)

func start_dialogue(start_node: String) -> void:
	current_node = start_node
	show_node()

# =========================================================
# 显示当前节点
# =========================================================
func show_node() -> void:
	clear_choices()
	awaiting_choice = false

	if not dialogue.has(current_node):
		printerr("Missing node: ", current_node, " in scene: ", current_scene_id)
		return

	var node = dialogue[current_node]
	var npc_name = node.get("npc", "")
	var line_text = node.get("text", "")
	
	npc_name_text.text = npc_name+":"
	var prefix = ""
	text.text = prefix + line_text
	
	var pic_res = ""
	if npc_name == "Conductor":
		pic_res = "res://Conductor.PNG"
	elif npc_name == "Greed":
		pic_res = "res://Greed Holder.PNG"
	elif npc_name == "Charity":
		pic_res = "res://charity.PNG"
	elif npc_name == "Trust":
		pic_res = "res://trust.PNG"
	
	%Conductor.texture = load(pic_res)
	
	if node.has("response") and String(node["response"]).length() > 0:
		text.text += "\n" + String(node["response"])

	if node.has("options"):
		awaiting_choice = true
		for opt in node["options"]:
			add_choice(opt.get("text",""), opt.get("next",""))
	elif node.has("next"):
		await %nextbtn.pressed
		current_node = node["next"]
		show_node()
	else:
		await %nextbtn.pressed
		advance_scene_or_result()

# =========================================================
# 添加选项按钮
# =========================================================
func add_choice(choice_text: String, next_node: String) -> void:
	var btn := Button.new()
	btn.text = choice_text
	btn.pressed.connect(func(): _on_choice_pressed(choice_text, next_node))
	buttonlist.add_child(btn)

# =========================================================
# 点击选项（修改全局数值）
# =========================================================
func _on_choice_pressed(choice_text: String, next_node: String) -> void:
	%click_effect.play()
	for c in buttonlist.get_children():
		if c is Button:
			c.disabled = true

	# ——关键选项影响——
	# S1
	if choice_text == "Whatever way the train is going.":
		Game.greed += 1
	elif choice_text == "No…":
		Game.trust += 1
	elif choice_text == "Walking, probably.":
		Game.trust += 1

	# S2（Greed & Charity）
	if choice_text == "Uh, no thanks." or choice_text == "No thanks.":
		Game.greed -= 1
	elif choice_text == "Sure.":
		Game.greed += 1
	elif choice_text == "Isn't that an MLM?":
		Game.greed -= 1
	elif choice_text == "Give bread":
		Game.charity += 1
	elif choice_text == "Oh, uh, no…":
		Game.greed += 1
	elif choice_text == "You're still talking about that?":
		Game.greed += 0
	elif choice_text.find("leave her with me") != -1:
		Game.charity += 1
		Game.trust += 1

	# S3/S5（面对 Conductor 的态度）
	if choice_text == "No, sir. I'll leave." or choice_text == "I don't think I need a ticket.":
		Game.trust -= 1
	elif choice_text == "I don't expect it, but I am hoping you will let me stay.":
		Game.trust += 1

	# S4/S6（与小女孩建立信任）
	if choice_text == "Give a small smile, but say nothing.":
		Game.trust += 1
	elif choice_text == "I'll be sitting here for a while. Feel free to join me." or choice_text == "We're gonna be sitting here for a while. Feel free to join us.":
		Game.trust += 1

	clear_choices()
	awaiting_choice = false

	if next_node != "" and dialogue.has(next_node):
		current_node = next_node
		show_node()
	else:
		advance_scene_or_result()

# =========================================================
# 推进到“下一个场景”或“结算”
# =========================================================
func advance_scene_or_result() -> void:
	var idx := scene_order.find(current_scene_id)
	var next_scene_id := ""

	if current_scene_id == "S1_Tickets":
		next_scene_id = "S2_GreedCharity"
	elif current_scene_id == "S2_GreedCharity":
		next_scene_id = "S3_TheyLeave"
	elif current_scene_id == "S3_TheyLeave":
		if Game.charity >= 1 and Game.trust >= 1:
			next_scene_id = "S6_TrustWithCharity"
		elif Game.charity >= 1:
			next_scene_id = "S5_CharitySits"
		else:
			next_scene_id = "S4_TrustNoCharity"
	else:
		if idx != -1 and idx + 1 < scene_order.size():
			next_scene_id = scene_order[idx + 1]

	if next_scene_id != "":
		var start_node := get_scene_default_start(next_scene_id)
		start_scene(next_scene_id, start_node)
	else:
		show_result()

func get_scene_default_start(scene_id: String) -> String:
	match scene_id:
		"S1_Tickets":
			return "Tickets?"
		"S2_GreedCharity":
			return "Greet"
		"S3_TheyLeave":
			return "Return"
		"S4_TrustNoCharity":
			return "Hide"
		"S5_CharitySits":
			return "Start"
		"S6_TrustWithCharity":
			return "Hide"
		_:
			var keys = scenes.get(scene_id, {}).keys()
			return keys[0] if keys.size() > 0 else ""

# =========================================================
# 结局
# =========================================================
func show_result() -> void:
	clear_choices()

	var g = Game.greed
	var c = Game.charity
	var t = Game.trust

	print("⚖️ 结局判断 → Greed:", g, "Charity:", c, "Trust:", t)
	%bgm.stop()
	if g <= -1 or c >= 2 or t >= 1:
		%end_effect1.play()
		text.text = "✨ GOOD ENDING ✨\nGreed: %d  Charity: %d  Trust: %d" % [g, c, t]
	elif g >= 2:
		%end_effect2.play()
		text.text = "🔥 EVIL ENDING 🔥\nGreed: %d  Charity: %d  Trust: %d" % [g, c, t]
	else:
		%end_effect3.play()
		text.text = "🌫️ NEUTRAL ENDING 🌫️\nGreed: %d  Charity: %d  Trust: %d" % [g, c, t]

# =========================================================
# 工具函数
# =========================================================
func clear_choices() -> void:
	for c in buttonlist.get_children():
		c.queue_free()

func _unhandled_input(event) -> void:
	if event.is_action_pressed("ui_accept") and not awaiting_choice:
		if dialogue.has(current_node):
			var node = dialogue[current_node]
			if node.has("next"):
				current_node = node["next"]
				show_node()
			else:
				advance_scene_or_result()
