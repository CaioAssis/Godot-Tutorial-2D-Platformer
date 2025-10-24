extends Node
class_name  State

@warning_ignore('unused_signal')
signal Transitioned

var parent: PlatformPlayer = null

##Descreve o que acontece na entrada do estado.
##Exemplo: Randomizar um timer para ação é feita aqui
func Enter():
	pass

##Descreve o que acontece na saída do estado.
func Exit():
	pass

##Descreve a ação a ser realizada em relação a processamento
func Update(_delta: float):
	pass

##Descreve a ação a ser realizada em relação a movimentação
func Physics_Update(_delta: float):
	pass
