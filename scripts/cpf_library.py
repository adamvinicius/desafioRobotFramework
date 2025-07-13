from random import randint

def gerar_cpf_valido():
    def calc_digito(digs):
        s = sum(int(d)*w for d, w in zip(digs, range(len(digs)+1, 1, -1)))
        r = 11 - s % 11
        return '0' if r >= 10 else str(r)

    n = [str(randint(0, 9)) for _ in range(9)]
    n.append(calc_digito(n))
    n.append(calc_digito(n))
    return ''.join(n)