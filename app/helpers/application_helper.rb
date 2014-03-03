module ApplicationHelper

  def d2r(d)
    pi = 3.1415926535
    return  d*pi/180.0
  end

  def transform(radec, matrix)
    pi = 3.1415926535
    r0 = [Math.cos(radec[0]) * Math.cos(radec[1]),
    Math.sin(radec[0]) * Math.cos(radec[1]),
    Math.sin(radec[1])]

    s0 = [r0[0] * matrix[0] + r0[1] * matrix[1] + r0[2] * matrix[2],
    r0[0] * matrix[3] + r0[1] * matrix[4] + r0[2] * matrix[5],
    r0[0] * matrix[6] + r0[1] * matrix[7] + r0[2] * matrix[8]]

    r = Math.sqrt(s0[0] * s0[0] + s0[1] * s0[1] + s0[2] * s0[2])

    result = [0.0, 0.0]
    result[1] = Math.asin(s0[2] / r)
    cosaa = ((s0[0] / r) / Math.cos(result[1]))
    sinaa = ((s0[1] / r) / Math.cos(result[1]))
    result[0] = Math.atan2(sinaa, cosaa)
    result[0] = result[0] + 2*pi if (result[0] < 0.0)
    return result
  end

  def gal2equ(l,b)
    coords = [d2r(l), d2r(b)]
    out = transform(coords, [-0.0548755604, 0.4941094279, -0.8676661490,-0.8734370902, -0.4448296300, -0.1980763734, -0.4838350155, 0.7469822445, 0.4559837762])
    return [out[0] * (180.0/3.1415926535), out[1] * (180.0/3.1415926535)]
  end

  def equ2gal(ra,dec)
    coords = [d2r(ra), d2r(dec)]
    out = transform(coords, [-0.054876, -0.873437, -0.483835, 0.494109, -0.444830, 0.746982, -0.867666, -0.198076, 0.455984])
    return [out[0] * (180.0/3.1415926535), out[1] * (180.0/3.1415926535)]
  end

  def mag2flux(mag,band)
    f_0 = {"U" => 1810.0,"B" => 4260.0,"V" => 3540.0,"R" => 2870.0,"I" => 2250.0,"J" => 1670.0,"H" => 980.0,"K" => 620.0,"L" => 280.0,"M" => 150.0}
    if f_0.has_key?(band)
      mag ? flux = f_0[band]*10**(-mag/2.5) : 0.0
    else
      mag = ""
    end
  end

  def flux2mag(flux,band)
    f_0 = {"U" => 1810.0,"B" => 4260.0,"V" => 3540.0,"R" => 2870.0,"I" => 2250.0,"J" => 1670.0,"H" => 980.0,"K" => 620.0,"L" => 280.0,"M" => 150.0}
    if f_0.has_key?(band)
      flux ? mag = -2.5*(Math.log(flux/f_0[band]))/Math.log(10) : 0.0
    else
      flux = ""
    end
  end

  def mean(array)
    array.inject(0) { |sum, x| sum += x } / array.size.to_f
  end

  def variance(array)
    m = mean(array)
    variance = array.inject(0) { |variance, x| variance += (x - m) ** 2 }
    return variance
  end

  def stdev(array)
    return Math.sqrt(variance(array)/(array.size-1))
  end

end
