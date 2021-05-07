# What would the battery range be? The local start-up competition
# considers a battery powered torpedo pulling a hang-glider!
#
# Run line by line in the REPL, or ctrl + enter in VSCode

using MechanicalUnits
@import_expand ~W
kWh = kW*h

begin
    "Battery capability"
    E_battery = 200kWh
    "Diameter torpedo"
    D_torpedo = 0.5m
    "Area, hangglider"
    A_hangglider = 20m²
    "Glide ratio, hangglider"
    Cl_per_Cd = 15
    "Mass, hangglider and pilot"
    m_t = 22kg + 70kg
    "Efficiency, torpedo"
    η = 0.3
    "Drag coefficient, torpedo"
    C_d = 0.2
    "Density, water"
    ρ_w = 1026kg/m³
    "Density, air"
    ρ_a = 1.25kg/m³
    "Velocity, torpedo and hangglider"
    v = 50km/h

    "
    resistance(C, ρ::Density, v::Velocity, A::Area)
    -> ::Force
    "
    resistance(C, ρ::Density, v::Velocity, A::Area) = (1/2) * ρ * C  * A * v^2 |> N
end

lift = m_t * g

drag_hangglider = lift / Cl_per_Cd |> N

drag_torpedo = resistance(C_d, ρ_w, v, (π / 4) * D_torpedo^2 )

range_torpedo_hangglider = E_battery * η / (drag_torpedo + drag_hangglider) |> km