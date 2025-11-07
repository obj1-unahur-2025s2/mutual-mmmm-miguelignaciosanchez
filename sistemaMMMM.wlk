// ACTIVIDAD - Clase Abstracta Base
class Actividad {
    method idiomas()
    method implicaEsfuerzo()
    method sirveBroncearse()
    method dias()
    method esInteresante() {
        return self.idiomas().size() > 1
    }
    method esRecomendadaPara(socio)
}

// VIAJE - Clase Abstracta
class Viaje inherits Actividad {
    const idiomas = #{}
    override method idiomas() = idiomas
    override method esRecomendadaPara(socio) {
        return self.esInteresante() and socio.leAtrae(self) and not socio.yaRealizo(self)
    }
}

// VIAJE DE PLAYA
class ViajesPlaya inherits Viaje {
    var largo
    method largo() = largo
    override method dias() = largo / 500
    override method implicaEsfuerzo() = largo > 1200
    override method sirveBroncearse() = true
}

// EXCURSIÓN A CIUDAD
class ExcursionCiudad inherits Viaje {
    var cantidadAtracciones
    method cantidadAtracciones() = cantidadAtracciones
    override method dias() = cantidadAtracciones / 2
    override method implicaEsfuerzo() = cantidadAtracciones.between(5, 8)
    override method sirveBroncearse() = false
    override method esInteresante() {
        return super() or cantidadAtracciones == 5
    }
}

// EXCURSIÓN A CIUDAD TROPICAL
class ExcursionCiudadTropical inherits ExcursionCiudad {
    override method dias() = super() + 1
    override method sirveBroncearse() = true
}

// SALIDA DE TREKKING
class SalidaTrekking inherits Viaje {
    var kilometrosSenderos
    var diasSolPorAño
    method kilometrosSenderos() = kilometrosSenderos
    method diasSolPorAño() = diasSolPorAño
    override method dias() = kilometrosSenderos / 50
    override method implicaEsfuerzo() = kilometrosSenderos > 80
    override method sirveBroncearse() {
        return diasSolPorAño > 200 or 
               (diasSolPorAño.between(100, 200) and kilometrosSenderos > 120)
    }
    override method esInteresante() {
        return super() and diasSolPorAño > 140
    }
}

// CLASE DE GIMNASIA
class ClaseGimnasia inherits Actividad {
    override method idiomas() = #{"español"}
    override method dias() = 1
    override method implicaEsfuerzo() = true
    override method sirveBroncearse() = false
    override method esInteresante() = false
    override method esRecomendadaPara(socio) {
        return socio.edad().between(20, 30)
    }
}

// LIBRO (Para el Bonus)
class Libro {
    var idioma
    var cantidadPaginas
    var autor
    method idioma() = idioma
    method cantidadPaginas() = cantidadPaginas
    method autor() = autor
}

// TALLER LITERARIO (Bonus)
class TallerLiterario inherits Actividad {
    const libros = #{}
    method libros() = libros
    override method idiomas() {
        return libros.map({libro => libro.idioma()})
    }
    override method dias() = libros.size() + 1
    override method implicaEsfuerzo() {
        return self.tieneLibroLargo() or self.todosDelMismoAutor()
    }
    method tieneLibroLargo() {
        return libros.any({libro => libro.cantidadPaginas() > 500})
    }
    method todosDelMismoAutor() {
        return libros.size() > 1 and 
               libros.map({libro => libro.autor()}).asSet().size() == 1
    }
    override method sirveBroncearse() = false
    override method esRecomendadaPara(socio) {
        return socio.idiomas().size() > 1
    }
}

// SOCIO - Clase Base
class Socio {
    var edad
    const idiomas = #{}
    const actividadesRealizadas = #{}
    var maxActividades
    method edad() = edad
    method idiomas() = idiomas
    method actividadesRealizadas() = actividadesRealizadas
    method maxActividades() = maxActividades
    method esAdoradorDelSol() {
        return actividadesRealizadas.all({actividad => actividad.sirveBroncearse()})
    }
    method actividadesEsforzadas() {
        return actividadesRealizadas.filter({actividad => actividad.implicaEsfuerzo()})
    }
    method realizarActividad(actividad) {
        if(actividadesRealizadas.size() >= maxActividades) {
            self.error("Ya llegó al máximo de actividades")
        }
        actividadesRealizadas.add(actividad)
    }
    method leAtrae(actividad)
    method yaRealizo(actividad) {
        return actividadesRealizadas.contains(actividad)
    }
}

// SOCIO TRANQUILO
class SocioTranquilo inherits Socio {
    override method leAtrae(actividad) {
        return actividad.dias() >= 4
    }
}

// SOCIO COHERENTE
class SocioCoherente inherits Socio {
    override method leAtrae(actividad) {
        if(self.esAdoradorDelSol()) {
            return actividad.sirveBroncearse()
        } else {
            return actividad.implicaEsfuerzo()
        }
    }
}

// SOCIO RELAJADO
class SocioRelajado inherits Socio {
    override method leAtrae(actividad) {
        return self.hablaAlgunIdiomaDe(actividad)
    }
    method hablaAlgunIdiomaDe(actividad) {
        return idiomas.any({idioma => actividad.idiomas().contains(idioma)})
    }
}