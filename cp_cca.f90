program gbm_from_csv
    implicit none
    integer, parameter :: dp = selected_real_kind(15, 307)
    integer, parameter :: n_sim = 1000000
    integer, parameter :: max_lines = 10000
    real(dp), dimension(max_lines) :: prices, returns
    integer :: n, n_ret, i, count_up
    real(dp) :: mu, sigma, s0, T, drift, diffusion, z, rnd1, rnd2
    real(dp) :: prob_up, mean, var, sum_ret
    character(len=200) :: line
    character(len=100) :: filename
    logical :: endfile_reached
    integer :: ios
    real(dp) :: pi
    pi = 4.0_dp * atan(1.0_dp)

    filename = "NVidia_stock_history.csv"

    ! Read prices from CSV file
    n = 0
    open(unit=10, file=filename, status='old', action='read', iostat=ios)
    if (ios /= 0) then
        print *, "Error opening file:", trim(filename)
        stop
    end if

    read(10, '(A)', iostat=ios) line  ! skip header

    do
        read(10, '(A)', iostat=ios) line
        if (ios /= 0) exit

        call parse_close_price(line, prices(n+1), ios)
        if (ios == 0) n = n + 1
        if (n >= max_lines) exit
    end do
    close(10)

    if (n < 2) then
        print *, "Not enough data in file."
        stop
    end if

    ! Compute daily log returns
    n_ret = n - 1
    do i = 1, n_ret
        returns(i) = log(prices(i+1) / prices(i))
    end do

    ! Estimate mean and variance
    sum_ret = sum(returns(1:n_ret))
    mean = sum_ret / n_ret
    var = sum((returns(1:n_ret) - mean)**2) / (n_ret - 1)

    mu = mean + 0.5_dp * var
    sigma = sqrt(var)

    s0 = prices(n)
    T = 0.002739_dp

    print *, "-----------------------------------------"
    print *, "Loaded", n, "price points from", trim(filename)
    print '(A,F10.6)', "Estimated mu (drift): ", mu
    print '(A,F10.6)', "Estimated sigma (volatility): ", sigma
    print '(A,F10.2)', "Starting Price (last close): ", s0
    print *, "-----------------------------------------"

    ! Monte Carlo simulation
    call random_seed()
    count_up = 0
    drift = (mu - 0.5_dp * sigma**2) * T
    diffusion = sigma * sqrt(T)

    do i = 1, n_sim
        call random_number(rnd1)
        call random_number(rnd2)
        z = sqrt(-2.0_dp * log(rnd1)) * cos(2.0_dp * pi * rnd2)
        if (s0 * exp(drift + diffusion * z) > s0) count_up = count_up + 1
    end do

    prob_up = real(count_up, dp) / real(n_sim, dp)

    print '(A,F8.4)', "Probability Price Goes Up:   ", prob_up
    print '(A,F8.4)', "Probability Price Goes Down: ", 1.0_dp - prob_up
    print *, "-----------------------------------------"

contains

    subroutine parse_close_price(line, price, ios)
        implicit none
        character(len=*), intent(in) :: line
        real(dp), intent(out) :: price
        integer, intent(out) :: ios
        character(len=200) :: temp_line
        character(len=30) :: token
        integer :: i, p1, p2, comma_count

        ios = 0
        temp_line = line
        comma_count = 0
        p1 = 1

        ! Find the 5th column ("Close")
        do i = 1, len_trim(temp_line)
            if (temp_line(i:i) == ',') comma_count = comma_count + 1
            if (comma_count == 4) then
                p1 = i + 1
                exit
            end if
        end do

        if (p1 <= len_trim(temp_line)) then
            p2 = index(temp_line(p1:), ",")
            if (p2 == 0) p2 = len_trim(temp_line) - p1 + 1
            token = adjustl(temp_line(p1:p1+p2-2))
            read(token, *, iostat=ios) price
        else
            ios = 1
        end if
    end subroutine parse_close_price

end program gbm_from_csv

