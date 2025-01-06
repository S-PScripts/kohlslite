-- Only obfuscated to see how smart people are
-- For the usage, check https://pastebin.com/raw/urXdpj6W

("For usage, check the comment"):gsub(
    ".+",
    (function(a)
        _XztvMMea_owa = a
    end)
)
return (function(u, ...)
    local r
    local a
    local d
    local o
    local s
    local t
    local e = 24915
    local n = 0
    local l = {}
    while n < 483 do
        n = n + 1
        while n < 0x14f and e % 0x2a8c < 0x1546 do
            n = n + 1
            e = (e - 566) % 25062
            local f = n + e
            if (e % 0x2972) >= 0x14b9 then
                e = (e + 0x1c) % 0x84c
                while n < 0x295 and e % 0x1564 < 0xab2 do
                    n = n + 1
                    e = (e - 899) % 12449
                    local a = n + e
                    if (e % 0x41b6) < 0x20db then
                        e = (e + 0x1b7) % 0x5afe
                        local e = 38770
                        if not l[e] then
                            l[e] = 0x1
                            t = function(t)
                                local e = 0x01
                                local function l(n)
                                    e = e + n
                                    return t:sub(e - n, e - 0x01)
                                end
                                while true do
                                    local n = l(0x01)
                                    if (n == "\5") then
                                        break
                                    end
                                    local e = o.byte(l(0x01))
                                    local e = l(e)
                                    if n == "\2" then
                                        e = r.qVSD_Ryp(e)
                                    elseif n == "\3" then
                                        e = e ~= "\0"
                                    elseif n == "\6" then
                                        d[e] = function(e, n)
                                            return u(8, nil, u, n, e)
                                        end
                                    elseif n == "\4" then
                                        e = d[e]
                                    elseif n == "\0" then
                                        e = d[e][l(o.byte(l(0x01)))]
                                    end
                                    local n = l(0x08)
                                    r[n] = e
                                end
                            end
                        end
                    elseif e % 2 ~= 0 then
                        e = (e - 0x3e2) % 0x7183
                        local e = 74115
                        if not l[e] then
                            l[e] = 0x1
                        end
                    else
                        e = (e * 0x32e) % 0x85b8
                        n = n + 1
                        local e = 36845
                        if not l[e] then
                            l[e] = 0x1
                        end
                    end
                end
            elseif e % 2 ~= 0 then
                e = (e + 0x33) % 0x873
                while n < 0x223 and e % 0x3062 < 0x1831 do
                    n = n + 1
                    e = (e * 678) % 26177
                    local d = n + e
                    if (e % 0x390a) >= 0x1c85 then
                        e = (e * 0x1d9) % 0x8b4b
                        local e = 84240
                        if not l[e] then
                            l[e] = 0x1
                            s = tonumber
                        end
                    elseif e % 2 ~= 0 then
                        e = (e * 0x241) % 0x7936
                        local e = 52894
                        if not l[e] then
                            l[e] = 0x1
                            r = {}
                        end
                    else
                        e = (e + 0x363) % 0x9628
                        n = n + 1
                        local e = 29595
                        if not l[e] then
                            l[e] = 0x1
                            a =
                                "\4\8\116\111\110\117\109\98\101\114\113\86\83\68\95\82\121\112\0\6\115\116\114\105\110\103\4\99\104\97\114\87\102\112\71\106\98\72\88\0\6\115\116\114\105\110\103\3\115\117\98\117\75\111\106\75\108\68\68\0\6\115\116\114\105\110\103\4\98\121\116\101\106\98\74\73\110\97\71\87\0\5\116\97\98\108\101\6\99\111\110\99\97\116\120\108\65\71\114\81\107\116\0\5\116\97\98\108\101\6\105\110\115\101\114\116\73\97\86\74\112\70\114\66\5"
                        end
                    end
                end
            else
                e = (e + 0x282) % 0x68c2
                n = n + 1
                while n < 0x2fa and e % 0xd22 < 0x691 do
                    n = n + 1
                    e = (e - 227) % 14614
                    local t = n + e
                    if (e % 0x2222) > 0x1111 then
                        e = (e + 0x398) % 0x3793
                        local e = 48715
                        if not l[e] then
                            l[e] = 0x1
                            d = (not d) and _ENV or d
                        end
                    elseif e % 2 ~= 0 then
                        e = (e - 0x377) % 0xad85
                        local e = 26436
                        if not l[e] then
                            l[e] = 0x1
                            o = string
                        end
                    else
                        e = (e * 0x154) % 0x5665
                        n = n + 1
                        local e = 10787
                        if not l[e] then
                            l[e] = 0x1
                            d = getfenv and getfenv()
                        end
                    end
                end
            end
        end
        e = (e + 715) % 1700
    end
    t(a)
    local n = {}
    for e = 0x0, 0xff do
        local l = r.WfpGjbHX(e)
        n[e] = l
        n[l] = e
    end
    local function c(e)
        return n[e]
    end
    local a = (function(f, o)
        local a, l = 0x01, 0x10
        local n = {{}, {}, {}}
        local d = -0x01
        local e = 0x01
        local t = f
        while true do
            n[0x03][
                    r.uKojKlDD(
                        o,
                        e,
                        (function()
                            e = a + e
                            return e - 0x01
                        end)()
                    )
                ] = (function()
                d = d + 0x01
                return d
            end)()
            if d == (0x0f) then
                d = ""
                l = 0x000
                break
            end
        end
        local d = #o
        while e < d + 0x01 do
            n[0x02][l] =
                r.uKojKlDD(
                o,
                e,
                (function()
                    e = a + e
                    return e - 0x01
                end)()
            )
            l = l + 0x01
            if l % 0x02 == 0x00 then
                l = 0x00
                r.IaVJpFrB(
                    n[0x01],
                    (c((((n[0x03][n[0x02][0x00]] or 0x00) * 0x10) + (n[0x03][n[0x02][0x01]] or 0x00) + t) % 0x100))
                )
                t = f + t
            end
        end
        return r.xlAGrQkt(n[0x01])
    end)
    t(a(158, "3(oh<{/XRF,N._w}/X"))
    t(
        a(
            2,
            "+EYAqRG}Jx#/-9w**wlYG9G-GJR9GKR}*YR,R*RRRGY}RuqRYRYYE9AxE#9J9}qFAEY9AGAqE-A}i9_qAs**8G2>/}/xYYYYE}E#EwvPS&*9EJ;*T}TRwRxJx-5}jG6Y*}*#*EJ9*AwR*GwAwG-/9x9v/w9A9G9}-qG-Gw9R-}9J-#GR-#-T/*9y-G/R#/x}-q#wx}/Ex&qJqw/A#A/z#}x9##xR#GxExrxJJ*J9J9}EJ-}eG}}RGYE-E9G#}}}AJY}/}-A/Gx}GqJqEGw}qR-RB*#*JGxRER}GfG?YxqxRqA}qGqYRA9-9xn*EwYEE-q3AEA/EJ_/-J-#AqY9Y*YwY#E*YYExzxlYEG*EE}wJ*qwG#H#AE(*/*# Y*xxJcR*-*-w/w/*E*-w#9J-YwqwwwG/x}J}JwR9-9--/-/9E-}9G/J/q#Y/*#w--RJR}-T-K/R/J/-xE/}/R/JxB}9###xA#A##RxRx#xEJ9x-}AxEJEG*GAxaxYGYEGEJ}*}EJY}qv*Gw}Y}A}E}YGqGx}Aq9AJqyA#A9*A"
        )
    )
    local e =
        (-15883 +
        (function()
            local t, l = 0, 1
            (function(l, d, e, n)
                e(
                    e(n, n and e, e, n) and d(d, e, l and l, n),
                    d(e, d, n, l and e),
                    n(e, e, e, l),
                    l(l, e, n, d) and n(d, l, l, n)
                )
            end)(
                function(n, d, e, o)
                    if t > 297 then
                        return e
                    end
                    t = t + 1
                    l = (l - 188) % 3110
                    if (l % 1246) > 623 then
                        l = (l * 862) % 25450
                        return n
                    else
                        return e(
                            o(n and n, o, e, n and n) and o(n, o, e, e),
                            n(n, o, e and o, d and e) and o(e, d, d, n),
                            d(n, e, n and n, o),
                            n(n, o and d, e and n, n)
                        )
                    end
                    return n(d(d, d and o, o and d, e), e(o, e, n, e), e(n and d, e, n, e and e), d(d, e and e, e, e))
                end,
                function(e, d, n, o)
                    if t > 330 then
                        return o
                    end
                    t = t + 1
                    l = (l + 124) % 37944
                    if (l % 340) <= 170 then
                        l = (l + 474) % 48389
                        return d
                    else
                        return n(
                            e(e, n, d, e),
                            n(n, d and n, o, d and e),
                            e(e, o and e, n and e, d) and e(e, e, n, d and e),
                            d(o, e, e, e)
                        )
                    end
                    return d(
                        n(d and o, d, n, d),
                        n(o, n, o and n, e) and d(n, o and d, e, n),
                        n(d, n and e, o, n),
                        d(o, n, d, e and o)
                    )
                end,
                function(o, d, e, n)
                    if t > 146 then
                        return o
                    end
                    t = t + 1
                    l = (l - 803) % 43313
                    if (l % 1390) > 695 then
                        l = (l + 725) % 17909
                        return d
                    else
                        return e(e(n, n, n, e), n(e, n, o, o), o(n and d, o, e, o), n(n, e and e, d, d))
                    end
                    return n(
                        d(e, e and n, o, e),
                        n(e, n, e, d),
                        d(e, d, o, d) and n(e and d, e, d, d),
                        o(n, e, e, o and d)
                    )
                end,
                function(d, e, o, n)
                    if t > 116 then
                        return d
                    end
                    t = t + 1
                    l = (l * 365) % 5028
                    if (l % 1198) >= 599 then
                        return o(e(e, e, n, n), d(e, d, n, n), e(d, e, o, n), d(n, n and e, e, n))
                    else
                        return d
                    end
                    return o
                end
            )
            return l
        end)())
    local y = (getfenv) or (function()
            return _ENV
        end)
    local h = r.ctXVFeVv or r.xhXDhtnC
    local f = 4
    local m = 1
    local t = 2
    local d = 3
    local function g(p, ...)
        local a =
            a(
            e,
            "y-cp>9vDAl!G85jT-D-c-Gc>cj>4pT>A9-8-8>5l5!jjjAxpk81D-jG95v8v8T5Acj9lvcv!9ADpD!DTD8!v!5!5GGG55cG15!5jjDT-Xp5T-Gc>cG8>8G5>55jv8Tc>T->!->cpc9cjpD!D!j8v8c8l5Gj8ACAjl-l!!p-9cpp-c8>c>5jpT{T>T5EvApDlAplvlApj>9>j9Dv_!l5jv!8>Ajl5lT!AG-b!cTc5pA>ppQ9>T!zTiG->-5A9ADGcG98{!e!l8!8T5vjT&0Tpl8!5!5GvGTTTe>WT-vc:clcjp!>9-!pjcGp>p5A8Gj8!A-5Tjv55j8Tp8p8Pf8-!cucDpATv9p9{9v-!vvDGAcAGA8lj!5>>>G9>T5-!AcTWA888l>!a!9!jGDcDc!pT>2jvj5TvTT{Al-Ajk>v8p9pj>D9C9lD8vGD>D5Avl8lA!-!!G>G8898jjlTGjlTcTGHv.5-v-Tp!>jp!>p>89j9jvDDwlTAjAGl>l5!8!TGl8-595pjHjAjjTDdHnT-c-8c>p-plpT>A9-v-vpv5D9DjA5lhll!c!8G>G58vj-Tcj-j!TpqV 9Sj-DcOplpcpG>>>j9vv-vAD-AcApA5l9!-!DG1Gl5>5>5>5TjvTcTA(-R!c9ppc9p-pD>D>l9c9GDvDjDvApAAlTl!!p!8G95p8D5-5ljvjGT9T5-vc5-Ac-c!p>p8>v>jvlDTvlDcDGl-A5lvlT8AGvG!8p88595jjTT3-T-8^G->-5p!cTpl>-9v9pvUvAvjDDA%l5lcl8!>G-GlGT8A5-Tpjpj5T9-Oc--)-lccp-p>p5>vvTv8v-v!DpD8A9lplDGcGAGcG88>8j5v5TjAxp-90pJj-9cAcDp4pl>c9A9>95vvD-DAAcA!lp!c!9!jGD8-8l5c5G"
        )
        local n = 0
        r.VsKDrCLH(
            function()
                r.vAcpUfdw()
                n = n + 1
            end
        )
        local function e(e, l)
            if l then
                return n
            end
            n = e + n
        end
        local l, n, c = u(0, u, e, a, r.jbJInaGW)
        local function o()
            local l, n = r.jbJInaGW(a, e(1, 3), e(5, 6) + 2)
            e(2)
            return (n * 256) + l
        end
        local j = true
        local j = 0
        local function _()
            local e = n()
            local n = n()
            local t = 1
            local d = (l(n, 1, 20) * (2 ^ 32)) + e
            local e = l(n, 21, 31)
            local n = ((-1) ^ l(n, 32))
            if (e == 0) then
                if (d == j) then
                    return n * 0
                else
                    e = 1
                    t = 0
                end
            elseif (e == 2047) then
                return (d == 0) and (n * (1 / 0)) or (n * (0 / 0))
            end
            return r.aYGvbMiJ(n, e - 1023) * (t + (d / (2 ^ 52)))
        end
        local b = n
        local function k(n)
            local l
            if (not n) then
                n = b()
                if (n == 0) then
                    return ""
                end
            end
            l = r.uKojKlDD(a, e(1, 3), e(5, 6) + n - 1)
            e(n)
            local e = ""
            for n = (1 + j), #l do
                e = e .. r.uKojKlDD(l, n, n)
            end
            return e
        end
        local j = #r.YTjGoBPD(s("\49.\48")) ~= 1
        local e = n
        local function z(...)
            return {...}, r.Mm_OEtxJ("#", ...)
        end
        local function g()
            local s = {}
            local h = {}
            local e = {}
            local u = {h, s, nil, e}
            local e = n()
            local a = {}
            for d = 1, e do
                local l = c()
                local e
                if (l == 3) then
                    e = (c() ~= #{})
                elseif (l == 2) then
                    local n = _()
                    if j and r.O_XH_dgV(r.YTjGoBPD(n), ".(\48+)$") then
                        n = r.fmyUBLHM(n)
                    end
                    e = n
                elseif (l == 1) then
                    e = k()
                end
                a[d] = e
            end
            for e = 1, n() do
                s[e - (#{1})] = g()
            end
            u[3] = c()
            for u = 1, n() do
                local e = c()
                if (l(e, 1, 1) == 0) then
                    local r = l(e, 2, 3)
                    local c = l(e, 4, 6)
                    local e = {o(), o(), nil, nil}
                    if (r == 0) then
                        e[d] = o()
                        e[f] = o()
                    elseif (r == #{1}) then
                        e[d] = n()
                    elseif (r == p[2]) then
                        e[d] = n() - (2 ^ 16)
                    elseif (r == p[3]) then
                        e[d] = n() - (2 ^ 16)
                        e[f] = o()
                    end
                    if (l(c, 1, 1) == 1) then
                        e[t] = a[e[t]]
                    end
                    if (l(c, 2, 2) == 1) then
                        e[d] = a[e[d]]
                    end
                    if (l(c, 3, 3) == 1) then
                        e[f] = a[e[f]]
                    end
                    h[u] = e
                end
            end
            return u
        end
        local function _(l, e, n)
            local d = e
            local d = n
            return s(r.O_XH_dgV(r.O_XH_dgV(({r.VsKDrCLH(l)})[2], e), n))
        end
        local function le(j, e, c)
            local function ne(...)
                local a, y, o, ee, _, n, g, k, p, s, b, l
                local e = 0
                while -1 < e do
                    if 2 >= e then
                        if e <= 0 then
                            a = u(6, 75, 1, 42, j)
                            y = u(6, 29, 2, 48, j)
                        else
                            if e ~= 1 then
                                n = -41
                                g = -1
                            else
                                o = u(6, 7, 3, 28, j)
                                _ = z
                                ee = 0
                            end
                        end
                    else
                        if e < 5 then
                            if 2 < e then
                                repeat
                                    if e > 3 then
                                        s = r.Mm_OEtxJ("#", ...) - 1
                                        b = {}
                                        break
                                    end
                                    k = {}
                                    p = {...}
                                until true
                            else
                                s = r.Mm_OEtxJ("#", ...) - 1
                                b = {}
                            end
                        else
                            if e > 3 then
                                for n = 31, 79 do
                                    if e > 5 then
                                        e = -2
                                        break
                                    end
                                    l = u(7)
                                    break
                                end
                            else
                                e = -2
                            end
                        end
                    end
                    e = e + 1
                end
                for e = 0, s do
                    if (e >= o) then
                        k[e - o] = p[e + 1]
                    else
                        l[e] = p[e + 1]
                    end
                end
                local e = s - o + 1
                local e
                local o
                local function u(...)
                    while true do
                    end
                end
                while true do
                    if n < -40 then
                        n = n + 42
                    end
                    e = a[n]
                    o = e[m]
                    if o >= 16 then
                        if 24 <= o then
                            if o > 27 then
                                if o <= 29 then
                                    if o >= 24 then
                                        repeat
                                            if o < 29 then
                                                l[e[t]] = c[e[d]]
                                                break
                                            end
                                            l[e[t]] = l[e[d]][e[f]]
                                        until true
                                    else
                                        l[e[t]] = c[e[d]]
                                    end
                                else
                                    if 30 == o then
                                        l[e[t]][e[d]] = l[e[f]]
                                    else
                                        for o = 0, 2 do
                                            if o < 1 then
                                                l[e[t]] = c[e[d]]
                                                n = n + 1
                                                e = a[n]
                                            else
                                                if -2 <= o then
                                                    repeat
                                                        if o ~= 2 then
                                                            l[e[t]] = l[e[d]][e[f]]
                                                            n = n + 1
                                                            e = a[n]
                                                            break
                                                        end
                                                        if (l[e[t]] ~= e[f]) then
                                                            n = n + 1
                                                        else
                                                            n = e[d]
                                                        end
                                                    until true
                                                else
                                                    if (l[e[t]] ~= e[f]) then
                                                        n = n + 1
                                                    else
                                                        n = e[d]
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            else
                                if o < 26 then
                                    if 24 == o then
                                        local n = e[t]
                                        local t = l[n]
                                        for e = n + 1, e[d] do
                                            r.IaVJpFrB(t, l[e])
                                        end
                                    else
                                        local e = e[t]
                                        l[e] = l[e]()
                                    end
                                else
                                    if 25 < o then
                                        for n = 40, 80 do
                                            if o < 27 then
                                                l[e[t]] = c[e[d]]
                                                break
                                            end
                                            l[e[t]] = {}
                                            break
                                        end
                                    else
                                        l[e[t]] = c[e[d]]
                                    end
                                end
                            end
                        else
                            if o < 20 then
                                if 18 > o then
                                    if o < 17 then
                                        local f, c
                                        for o = 0, 5 do
                                            if 3 > o then
                                                if 0 < o then
                                                    if o >= 0 then
                                                        for r = 45, 97 do
                                                            if o ~= 2 then
                                                                l[e[t]] = {}
                                                                n = n + 1
                                                                e = a[n]
                                                                break
                                                            end
                                                            l(e[t], e[d])
                                                            n = n + 1
                                                            e = a[n]
                                                            break
                                                        end
                                                    else
                                                        l(e[t], e[d])
                                                        n = n + 1
                                                        e = a[n]
                                                    end
                                                else
                                                    f = e[t]
                                                    l[f] = l[f]()
                                                    n = n + 1
                                                    e = a[n]
                                                end
                                            else
                                                if 4 <= o then
                                                    if o >= 1 then
                                                        for h = 27, 87 do
                                                            if o ~= 4 then
                                                                f = e[t]
                                                                c = l[f]
                                                                for e = f + 1, e[d] do
                                                                    r.IaVJpFrB(c, l[e])
                                                                end
                                                                break
                                                            end
                                                            l(e[t], e[d])
                                                            n = n + 1
                                                            e = a[n]
                                                            break
                                                        end
                                                    else
                                                        l(e[t], e[d])
                                                        n = n + 1
                                                        e = a[n]
                                                    end
                                                else
                                                    l(e[t], e[d])
                                                    n = n + 1
                                                    e = a[n]
                                                end
                                            end
                                        end
                                    else
                                        local e = e[t]
                                        l[e] = l[e]()
                                    end
                                else
                                    if o > 17 then
                                        repeat
                                            if 19 ~= o then
                                                l[e[t]] = {}
                                                break
                                            end
                                            c[e[d]] = l[e[t]]
                                        until true
                                    else
                                        c[e[d]] = l[e[t]]
                                    end
                                end
                            else
                                if 21 >= o then
                                    if 19 <= o then
                                        repeat
                                            if 21 > o then
                                                local r
                                                for o = 0, 3 do
                                                    if o < 2 then
                                                        if o >= -3 then
                                                            repeat
                                                                if o ~= 1 then
                                                                    l[e[t]] = l[e[d]][e[f]]
                                                                    n = n + 1
                                                                    e = a[n]
                                                                    break
                                                                end
                                                                l[e[t]] = c[e[d]]
                                                                n = n + 1
                                                                e = a[n]
                                                            until true
                                                        else
                                                            l[e[t]] = c[e[d]]
                                                            n = n + 1
                                                            e = a[n]
                                                        end
                                                    else
                                                        if o ~= 3 then
                                                            l(e[t], e[d])
                                                            n = n + 1
                                                            e = a[n]
                                                        else
                                                            r = e[t]
                                                            l[r](h(l, r + 1, e[d]))
                                                        end
                                                    end
                                                end
                                                break
                                            end
                                            l[e[t]] = (e[d] ~= 0)
                                        until true
                                    else
                                        local r
                                        for o = 0, 3 do
                                            if o < 2 then
                                                if o >= -3 then
                                                    repeat
                                                        if o ~= 1 then
                                                            l[e[t]] = l[e[d]][e[f]]
                                                            n = n + 1
                                                            e = a[n]
                                                            break
                                                        end
                                                        l[e[t]] = c[e[d]]
                                                        n = n + 1
                                                        e = a[n]
                                                    until true
                                                else
                                                    l[e[t]] = c[e[d]]
                                                    n = n + 1
                                                    e = a[n]
                                                end
                                            else
                                                if o ~= 3 then
                                                    l(e[t], e[d])
                                                    n = n + 1
                                                    e = a[n]
                                                else
                                                    r = e[t]
                                                    l[r](h(l, r + 1, e[d]))
                                                end
                                            end
                                        end
                                    end
                                else
                                    if 18 ~= o then
                                        repeat
                                            if o > 22 then
                                                l[e[t]][e[d]] = l[e[f]]
                                                break
                                            end
                                            l(e[t], e[d])
                                        until true
                                    else
                                        l(e[t], e[d])
                                    end
                                end
                            end
                        end
                    else
                        if 8 <= o then
                            if o <= 11 then
                                if 9 >= o then
                                    if 7 < o then
                                        repeat
                                            if 9 > o then
                                                if (l[e[t]] == e[f]) then
                                                    n = n + 1
                                                else
                                                    n = e[d]
                                                end
                                                break
                                            end
                                            if (l[e[t]] == e[f]) then
                                                n = n + 1
                                            else
                                                n = e[d]
                                            end
                                        until true
                                    else
                                        if (l[e[t]] == e[f]) then
                                            n = n + 1
                                        else
                                            n = e[d]
                                        end
                                    end
                                else
                                    if 7 <= o then
                                        for r = 38, 70 do
                                            if 11 ~= o then
                                                n = e[d]
                                                break
                                            end
                                            local n = e[t]
                                            l[n](h(l, n + 1, e[d]))
                                            break
                                        end
                                    else
                                        local n = e[t]
                                        l[n](h(l, n + 1, e[d]))
                                    end
                                end
                            else
                                if 14 <= o then
                                    if 11 <= o then
                                        for r = 27, 77 do
                                            if o ~= 15 then
                                                if (l[e[t]] ~= e[f]) then
                                                    n = n + 1
                                                else
                                                    n = e[d]
                                                end
                                                break
                                            end
                                            do
                                                return
                                            end
                                            break
                                        end
                                    else
                                        do
                                            return
                                        end
                                    end
                                else
                                    if 12 == o then
                                        local n = e[t]
                                        local t = l[n]
                                        for e = n + 1, e[d] do
                                            r.IaVJpFrB(t, l[e])
                                        end
                                    else
                                        for o = 0, 3 do
                                            if o > 1 then
                                                if 1 < o then
                                                    for r = 48, 55 do
                                                        if 3 > o then
                                                            l[e[t]] = c[e[d]]
                                                            n = n + 1
                                                            e = a[n]
                                                            break
                                                        end
                                                        if (l[e[t]] == e[f]) then
                                                            n = n + 1
                                                        else
                                                            n = e[d]
                                                        end
                                                        break
                                                    end
                                                else
                                                    l[e[t]] = c[e[d]]
                                                    n = n + 1
                                                    e = a[n]
                                                end
                                            else
                                                if o > -4 then
                                                    for r = 16, 75 do
                                                        if o > 0 then
                                                            c[e[d]] = l[e[t]]
                                                            n = n + 1
                                                            e = a[n]
                                                            break
                                                        end
                                                        l[e[t]] = (e[d] ~= 0)
                                                        n = n + 1
                                                        e = a[n]
                                                        break
                                                    end
                                                else
                                                    l[e[t]] = (e[d] ~= 0)
                                                    n = n + 1
                                                    e = a[n]
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            if 4 > o then
                                if 1 < o then
                                    if 1 < o then
                                        for r = 34, 75 do
                                            if o > 2 then
                                                n = e[d]
                                                break
                                            end
                                            if (l[e[t]] ~= e[f]) then
                                                n = n + 1
                                            else
                                                n = e[d]
                                            end
                                            break
                                        end
                                    else
                                        n = e[d]
                                    end
                                else
                                    if o == 1 then
                                        local n = e[t]
                                        l[n](h(l, n + 1, e[d]))
                                    else
                                        l(e[t], e[d])
                                    end
                                end
                            else
                                if 5 >= o then
                                    if o > 2 then
                                        repeat
                                            if o < 5 then
                                                c[e[d]] = l[e[t]]
                                                break
                                            end
                                            l[e[t]] = l[e[d]][e[f]]
                                        until true
                                    else
                                        l[e[t]] = l[e[d]][e[f]]
                                    end
                                else
                                    if o > 5 then
                                        for n = 37, 55 do
                                            if 6 < o then
                                                l[e[t]] = (e[d] ~= 0)
                                                break
                                            end
                                            do
                                                return
                                            end
                                            break
                                        end
                                    else
                                        do
                                            return
                                        end
                                    end
                                end
                            end
                        end
                    end
                    n = 1 + n
                end
            end
            return ne
        end
        local d = 0xff
        local c = {}
        local o = (1)
        local t = ""
        (function(n)
            local l = n
            local a = 0x00
            local e = 0x00
            l = {
                (function(f)
                    if a > 0x2c then
                        return f
                    end
                    a = a + 1
                    e = (e + 0x943 - f) % 0x16
                    return (e % 0x03 == 0x1 and (function(l)
                            if not n[l] then
                                e = e + 0x01
                                n[l] = (0x50)
                            end
                            return true
                        end) "EfVHD" and l[0x3](0x1d0 + f)) or (e % 0x03 == 0x0 and (function(l)
                                if not n[l] then
                                    e = e + 0x01
                                    n[l] = (0xb2)
                                end
                                return true
                            end) "wbYcc" and l[0x1](f + 0x35f)) or (e % 0x03 == 0x2 and (function(l)
                                if not n[l] then
                                    e = e + 0x01
                                    n[l] = (0x68)
                                    t = {t .. "\58 a", t}
                                    c[o] = g()
                                    o = o + ((not r.CneGFCaD) and 1 or 0)
                                    t[1] = "\58" .. t[1]
                                    d[2] = 0xff
                                end
                                return true
                            end) "zoTts" and l[0x2](f + 0x2d8)) or f
                end),
                (function(r)
                    if a > 0x21 then
                        return r
                    end
                    a = a + 1
                    e = (e + 0x94c - r) % 0x1d
                    return (e % 0x03 == 0x2 and (function(l)
                            if not n[l] then
                                e = e + 0x01
                                n[l] = (0xaa)
                                c[o] = y()
                                o = o + d
                            end
                            return true
                        end) "HI_MC" and l[0x1](0x2d3 + r)) or
                        (e % 0x03 == 0x1 and
                            (function(l)
                                if not n[l] then
                                    e = e + 0x01
                                    n[l] = (0x90)
                                    d[2] =
                                        (d[2] *
                                        (_(
                                            function()
                                                c()
                                            end,
                                            h(t)
                                        ) -
                                            _(d[1], h(t)))) +
                                        1
                                    c[o] = {}
                                    d = d[2]
                                    o = o + d
                                end
                                return true
                            end) "WZAZk" and
                            l[0x3](r + 0x8f)) or
                        (e % 0x03 == 0x0 and (function(l)
                                if not n[l] then
                                    e = e + 0x01
                                    n[l] = (0x9e)
                                end
                                return true
                            end) "vZGFD" and l[0x2](r + 0x12b)) or
                        r
                end),
                (function(o)
                    if a > 0x2e then
                        return o
                    end
                    a = a + 1
                    e = (e + 0x84a - o) % 0xc
                    return (e % 0x03 == 0x0 and (function(l)
                            if not n[l] then
                                e = e + 0x01
                                n[l] = (0xc6)
                            end
                            return true
                        end) "KHiYW" and l[0x3](0x3d7 + o)) or (e % 0x03 == 0x1 and (function(l)
                                if not n[l] then
                                    e = e + 0x01
                                    n[l] = (0xab)
                                    t = "\37"
                                    d = {function()
                                            d()
                                        end}
                                    t = t .. "\100\43"
                                end
                                return true
                            end) "MUHbu" and l[0x1](o + 0xe8)) or (e % 0x03 == 0x2 and (function(l)
                                if not n[l] then
                                    e = e + 0x01
                                    n[l] = (0xd3)
                                end
                                return true
                            end) "eMAbj" and l[0x2](o + 0x15b)) or o
                end)
            }
            l[0x3](0x1aee)
        end) {}
        local e = le(h(c))
        return e(...)
    end
    return g(
        (function()
            local n = {}
            local e = 0x01
            local l
            if r.CneGFCaD then
                l = r.CneGFCaD(g)
            else
                l = ""
            end
            if r.O_XH_dgV(l, r.XZYvoiiK) then
                e = e + 0
            else
                e = e + 1
            end
            n[e] = 0x02
            n[n[e] + 0x01] = 0x03
            return n
        end)(),
        ...
    )
end)(
    (function(e, l, n, t, d, o)
        local o
        if e >= 4 then
            if 5 >= e then
                if e >= 0 then
                    for o = 31, 68 do
                        if 4 < e then
                            local e = t
                            do
                                return function()
                                    local n = l(n, e(e, e), e(e, e))
                                    e(1)
                                    return n
                                end
                            end
                            break
                        end
                        local e = t
                        local t, o, a = d(2)
                        do
                            return function()
                                local r, d, l, n = l(n, e(e, e), e(e, e) + 3)
                                e(4)
                                return (n * t) + (l * o) + (d * a) + r
                            end
                        end
                        break
                    end
                else
                    local e = t
                    local o, t, d = d(2)
                    do
                        return function()
                            local r, l, n, a = l(n, e(e, e), e(e, e) + 3)
                            e(4)
                            return (a * o) + (n * t) + (l * d) + r
                        end
                    end
                end
            else
                if e >= 7 then
                    if 3 ~= e then
                        for l = 18, 98 do
                            if e ~= 7 then
                                do
                                    return n(e, nil, n)
                                end
                                break
                            end
                            do
                                return setmetatable(
                                    {},
                                    {["__\99\97\108\108"] = function(e, t, d, l, n)
                                            if n then
                                                return e[n]
                                            elseif l then
                                                return e
                                            else
                                                e[t] = d
                                            end
                                        end}
                                )
                            end
                            break
                        end
                    else
                        do
                            return n(e, nil, n)
                        end
                    end
                else
                    do
                        return d[n]
                    end
                end
            end
        else
            if e < 2 then
                if e ~= -4 then
                    repeat
                        if e ~= 0 then
                            do
                                return function(n, e, l)
                                    if l then
                                        local e = (n / 2 ^ (e - 1)) % 2 ^ ((l - 1) - (e - 1) + 1)
                                        return e - e % 1
                                    else
                                        local e = 2 ^ (e - 1)
                                        return (n % (e + e) >= e) and 1 or 0
                                    end
                                end
                            end
                            break
                        end
                        do
                            return l(1), l(4, d, t, n, l), l(5, d, t, n)
                        end
                    until true
                else
                    do
                        return function(n, e, l)
                            if l then
                                local e = (n / 2 ^ (e - 1)) % 2 ^ ((l - 1) - (e - 1) + 1)
                                return e - e % 1
                            else
                                local e = 2 ^ (e - 1)
                                return (n % (e + e) >= e) and 1 or 0
                            end
                        end
                    end
                end
            else
                if -1 <= e then
                    for o = 21, 69 do
                        if e ~= 3 then
                            do
                                return 16777216, 65536, 256
                            end
                            break
                        end
                        do
                            return l(1), l(4, d, t, n, l), l(5, d, t, n)
                        end
                        break
                    end
                else
                    do
                        return 16777216, 65536, 256
                    end
                end
            end
        end
    end),
    ...
)
