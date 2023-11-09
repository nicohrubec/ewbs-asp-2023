% get number of farms and markets
n_farms(N) :- N = #count{X, Y : f_prod(X, Y)}.
n_markets(M) :- M = #count{X, Y, Z: m_req(X, Y, Z)}.
market(M) :- m_req(M, Q, F).

% select subset of farms to be open
1 {f_open(1..N)} N :- n_farms(N).

% deliver up to max production from every open farm to every market
{transport_prod(J, 1..M, 1..C)} :- f_open(J), n_markets(M), f_prod(J, C).

% a farm cannot deliver different amounts to the same farm
:- transport_prod(F, M, D1), transport_prod(F, M, D2), D1!=D2.

% a farm cannot deliver more than it can produce
f_delivered(F, S) :- f_open(F), S = #sum{Q, M, F : transport_prod(F, M, Q), market(M)}.
:- f_delivered(F, S), f_open(F), f_prod(F, C), S > C.

% a market can receive resources from a maximum of farms
m_received_count(M, C) :- market(M), C = #count{F, M : transport_prod(F, M, _), f_open(F)}.
:- m_received_count(M, C), market(M), m_req(M, Q, F), C > F.

% each market needs to get exactly the requested amount of resources
m_received(M, S) :- market(M), S = #sum{Q, F, M : transport_prod(F, M, Q), f_open(F)}.
:- m_received(M, S), market(M), m_req(M, Q, F), S != Q.

% get transportation cost for each farm
farm_transport_cost(F, M, C*Q) :- f_open(F), market(M), transport_cost(M, F, C), transport_prod(F, M, Q).
farm_transport_cost_sum(F, S) :- f_open(F), S = #sum{C, F: farm_transport_cost(F, M, C)}.
farm_total(F, O+T) :- f_open(F), f_open_cost(F, O), farm_transport_cost_sum(F, T).

#minimize{S, F : farm_total(F, S), f_open(F)}.
