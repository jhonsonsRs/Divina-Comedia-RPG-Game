extends StaticBody2D

func quebrar_pelo_golem() -> void:
	print("A caixa quebrou e a Pedra apareceu!")
	# Instanciar a pedra que o player precisa pegar
	# colocar um som ou partículas de vidro quebrando.
	queue_free()
