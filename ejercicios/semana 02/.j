import math
import numpy as np
import matplotlib.pyplot as plt

ALLOWED_NAMES = {
    k: getattr(math, k)
    for k in dir(math)
    if not k.startswith("_")
}
ALLOWED_NAMES.update({
    "pi": math.pi,
    "e": math.e,
    "sqrt": math.sqrt,
    "abs": abs,
    "pow": pow,
})


def safe_eval(expr, x_value=None):
    names = dict(ALLOWED_NAMES)
    if x_value is not None:
        names["x"] = x_value
    return eval(expr, {"__builtins__": {}}, names)


def plot_expression(expr, x_min=-10, x_max=10, points=400):
    x = np.linspace(x_min, x_max, points)
    y = []
    for xi in x:
        try:
            y.append(safe_eval(expr, xi))
        except Exception:
            y.append(np.nan)
    plt.figure(figsize=(8, 5))
    plt.plot(x, y, label=expr)
    plt.axhline(0, color="black", linewidth=0.7)
    plt.axvline(0, color="black", linewidth=0.7)
    plt.title(f"Gráfica de: {expr}")
    plt.xlabel("x")
    plt.ylabel("y")
    plt.grid(True)
    plt.legend()
    plt.tight_layout()
    plt.show()


def main():
    print("Calculadora científica con gráfica")
    print("Escribe una expresión matemática para evaluar.")
    print("Para graficar, escribe: plot <expresión en x>")
    print("Funciones disponibles: sin, cos, tan, exp, log, sqrt, etc.")

    while True:
        try:
            entrada = input("-> ").strip()
        except EOFError:
            break

        if not entrada:
            continue
        if entrada.lower() in {"salir", "exit", "q"}:
            break

        if entrada.lower().startswith("plot "):
            expr = entrada[5:].strip()
            if not expr:
                print("Debe escribir una expresión después de 'plot'.")
                continue
            try:
                rango = input("Rango x_min,x_max (por defecto -10,10): ").strip()
                if rango:
                    parts = [float(v) for v in rango.split(",") if v.strip()]
                    if len(parts) == 2:
                        plot_expression(expr, parts[0], parts[1])
                    else:
                        print("Rango inválido. Usando valores por defecto.")
                        plot_expression(expr)
                else:
                    plot_expression(expr)
            except Exception as exc:
                print("Error al graficar:", exc)
        else:
            try:
                resultado = safe_eval(entrada)
                print(resultado)
            except Exception as exc:
                print("Error en la expresión:", exc)


if __name__ == "__main__":
    main()
