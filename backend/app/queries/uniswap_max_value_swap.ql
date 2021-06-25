{
    swaps(first:1, orderBy: amountUSD, orderDirection: desc, where: { to: "{{ address }}" }) {
    	amount0In
        amount1In
        amount0Out
    	amount1Out
        amountUSD
    }
}