#!/usr/bin/env julia
#

using CSV
using DataFrames
using Dates
using Plots

# Cargar el CSV en un DataFrame
df = CSV.read("masacres_2026_colombia_indepaz.csv", DataFrame)

# Resumen estadístico mínimo
describe(df)

# Convertir la columna "Fecha" a tipo Date usando el formato dd/mm/yyyy
df.Fecha = Date.(df.Fecha, dateformat"dd/mm/yyyy")

# Crear una columna con el periodo del mes (formato "YYYY-MM")
df.Mes = Dates.format.(df.Fecha, "yyyy-mm")

# Agrupar por mes y calcular la suma de víctimas (y conteo de eventos)
df_mensual = combine(
    groupby(df, :Mes),
    Symbol("Nº de Víctimas") => sum => :Total_Victimas,
    nrow => :Num_Masacres
)

p = bar(
    df_mensual.Mes,
    df_mensual.Total_Victimas,
    title = "Total de Víctimas de Masacres por Mes (Colombia 2026)",
    titlefontsize = 12,
    xlabel = "Mes",
    ylabel = "Número de Víctimas",
    legend = false,
    xrotation = 45,
    color = :crimson,
    yticks = 0:10:80
)

# Exportar
savefig(p, "victimas_masacres_2026.png")
savefig(p, "victimas_masacres_2026.pdf")
print("Plot generado como 'victimas_masacres_2026.png y .pdf")
