{
    swaps(orderBy: timestamp, where: { to: "{{ address }}" }) {
        id
        transaction {
            id
            timestamp
        }
        pair {
            token0 {
                symbol
            }
            token1 {
                symbol
            }
        }
        to
        sender
    }
}